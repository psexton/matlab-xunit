classdef XMLTestRunLogger < TestRunDisplay
    %VerboseTestRunDisplay Save results to an XML file
    %   See also TestRunDisplay, TestRunLogger, TestRunMonitor, TestSuite
    
    %   Steven L. Eddins
    %   Copyright 2010 The MathWorks, Inc.
    
    properties (SetAccess = private, GetAccess = private)
        TicStack = uint64([])
        Results = struct;
        TCNum = 0;
        FailureNum = 0;
        ErrorNum = 0;
        CurrentClass = '';
        ReportFile = '';
    end
    
    methods
        function self = XMLTestRunLogger(reportfile)
            if nargin < 1
                error('XMLTestRunLogger requires a file to write to');
            end
            self.ReportFile = reportfile;
            
            self.Results.ATTRIBUTE.name = 'MATLAB xUnit';
        end
        
        function testComponentStarted(self, component)
            %testComponentStarted Update Command Window display
            
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
            %testRunFinished
            
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
