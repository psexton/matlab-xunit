%XMLTestRunLogger Save test results to JUnit-compatible XML file
%   XMLTestRunLogger is a subclass of TestRunMonitor that collects
%   information from a TestSuite or TestCase as it runs, and then records
%   the results of all the tests to an XML file that is usable in various
%   external tools.  For instance, the Jenkins/Hudson continuous
%   integration server could run your tests every night, and make a pretty
%   web page with a graph of test failures.
%
%   To engage this class, use `runxunit -xmlfile output.xml`
%
%   See also TestRunDisplay, TestRunLogger, TestRunMonitor, TestSuite

%   Copyright 2011 Thomas G. Smith
%   https://github.com/tgs/matlab-xunit-doctest (xml branch)

classdef XMLTestRunLogger < TestRunMonitor
    
    properties (SetAccess = private, GetAccess = private)
        TicStack = uint64([])   % Keep track of several times at once
        Results = struct;   % will be transformed to xml
        TCNum = 0;          % the current test case
        FailureNum = 0;     % how many failures
        ErrorNum = 0;       % how many errors
        CurrentClass = '';  % the current file unit
        ReportFile = '';    % where to put the output
        ReportFileIdentifier = -1; % file identifier to be used as a target instead of a filename
    end
    
    methods
        function self = XMLTestRunLogger(reportfile)
            %XMLTestRunLogger Log test results to JUnit-compatible xml
            % XMLTestRunLogger(outputfile)
            if nargin < 1
                error('XMLTestRunLogger requires a file to write to');
            end

            if self.isValidFileIdentifier(reportfile)
                self.ReportFileIdentifier = reportfile;
                self.ReportFile = tempname;
            else
                self.ReportFile = reportfile;
            end
            
            self.Results.ATTRIBUTE.name = 'MATLAB xUnit';
        end
        
        function testComponentStarted(self, component)
            self.pushTic();
            
            if isa(component, 'TestCase')
                self.TCNum = self.TCNum + 1;
                self.Results.testcase{self.TCNum}.ATTRIBUTE.classname = self.CurrentClass;
                self.Results.testcase{end}.ATTRIBUTE.name = component.Name;
            elseif isa(component, 'TestSuite')
                self.testSuiteFinished()
                self.CurrentClass = component.Name;
            end
        end
        
        function testComponentFinished(self, component, did_pass)
            component_run_time = toc(self.popTic());
            
            if isa(component, 'TestCase')
                self.Results.testcase{end}.ATTRIBUTE.time = component_run_time;
            end
            
            if isempty(self.TicStack)
                self.testRunFinished();
            end
        end
        
        function testCaseFailure(self, test_case, failure_exception)
            self.FailureNum = self.FailureNum + 1;
            
            self.Results.testcase{end}.failure.ATTRIBUTE.type ...
                = failure_exception.identifier;
            
            self.Results.testcase{end}.failure.ATTRIBUTE.message ...
                = failure_exception.message;
            
            self.Results.testcase{end}.failure.CONTENT ...
                = failure_exception.getReport();
        end
        
        function testCaseError(self, test_case, error_exception)
            self.ErrorNum = self.ErrorNum + 1;
            
            self.Results.testcase{end}.failure.ATTRIBUTE.type ...
                = error_exception.identifier;
            
            self.Results.testcase{end}.failure.ATTRIBUTE.message ...
                = error_exception.message;
            
            self.Results.testcase{end}.failure.CONTENT ...
                = error_exception.getReport();
        end
        
    end
    
    methods (Access = protected)
        function writeResults(self, filename)
            self.Results.ATTRIBUTE.tests = self.TCNum;
            self.Results.ATTRIBUTE.skip = 0;
            self.Results.ATTRIBUTE.failures = self.FailureNum;
            self.Results.ATTRIBUTE.errors = self.ErrorNum;
            
            wPref.StructItem = false;
            wPref.CellItem = false;
            
            xml_write(filename, self.Results, 'testsuite', wPref);
            
            if self.ReportFileIdentifier > 0
                self.synchronizeReportFiles();
            end
        end
        
        % ONLY IF the ReportFile is a directory, write an xml file for each
        % suite.
        function testSuiteFinished(self)
            [~, filename] = fileparts(self.ReportFile);
            if isempty(filename) && ~isempty(self.CurrentClass)
                self.Results.ATTRIBUTE.name = self.CurrentClass;
                self.writeResults(self.getResultFileName());
                
                self.Results = struct;
                self.TCNum = 0;
            end
        end
        
        function testRunFinished(self)
            self.writeResults(self.getResultFileName());
        end
    end
    
    methods (Access = private)
        function value = isValidFileIdentifier(~, identifier)
            value = isnumeric(identifier) && any(identifier == fopen('all'));
        end
        
        function filename = getResultFileName(self)
            [pathname, filename] = fileparts(self.ReportFile);
            if isempty(filename)
                filename = fullfile(pathname, ['TEST-' self.CurrentClass '.xml']);
            else
                filename = self.ReportFile;
            end
        end
        
        function pushTic(self)
            self.TicStack(end+1) = tic;
        end
        
        function t1 = popTic(self)
            t1 = self.TicStack(end);
            self.TicStack(end) = [];
        end

        function synchronizeReportFiles(self)
            fwrite(self.ReportFileIdentifier, fileread(self.ReportFile));
        end
    end
    
end
