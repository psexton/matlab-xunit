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
    end
    
    methods
        function self = XMLTestRunLogger(reportfile)
            %XMLTestRunLogger Log test results to JUnit-compatible xml
            % XMLTestRunLogger(outputfile)
            if nargin < 1
                error('XMLTestRunLogger requires a file to write to');
            end
            self.ReportFile = reportfile;
            
            self.Results.ATTRIBUTE.name = 'MATLAB xUnit';
        end
        
        function testComponentStarted(self, component)
            self.pushTic();
            
            if isa(component, 'TestCase')
                self.TCNum = self.TCNum + 1;
                self.Results.testcase{self.TCNum}.ATTRIBUTE.classname = self.CurrentClass;
                self.Results.testcase{end}.ATTRIBUTE.name = component.Name;
            else
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
        function testRunFinished(self)
            self.Results.ATTRIBUTE.tests = self.TCNum;
            self.Results.ATTRIBUTE.skip = 0;
            self.Results.ATTRIBUTE.failures = self.FailureNum;
            self.Results.ATTRIBUTE.errors = self.ErrorNum;
            
            wPref.StructItem = false;
            wPref.CellItem = false;
            
            xml_write(self.ReportFile, self.Results, 'testsuite', wPref);
        end
    end
    
    methods (Access = private)
        function pushTic(self)
            self.TicStack(end+1) = tic;
        end
        
        function t1 = popTic(self)
            t1 = self.TicStack(end);
            self.TicStack(end) = [];
        end
    end
    
end
