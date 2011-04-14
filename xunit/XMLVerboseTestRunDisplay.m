classdef XMLVerboseTestRunDisplay < TestRunDisplay
%VerboseTestRunDisplay Print test suite execution results.
%   VerboseTestRunDisplay is a subclass of
%   TestRunDisplay.  It supports the -verbose option of runtests.
%
%   Overriddent methods:
%       testComponentStarted  - Update Command Window display
%       testComponentFinished - Update Command Window display
%       testRunFinished       - Update Command Window display at end of run
%
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
        function self = XMLVerboseTestRunDisplay(reportfile)
            if nargin < 1
                error('XMLVerboseTestRunDisplay requires a file to write to');
            end
            self.ReportFile = reportfile;
            
            self.Results.ATTRIBUTE.name = 'MATLAB xUnit';
            
        end
        
        function testComponentStarted(self, component)
            %testComponentStarted Update Command Window display
            
            self.pushTic();
            
            if isa(component, 'TestCase')
                self.TCNum = self.TCNum + 1;
%                 classLocation = component.Location;
%                 classLocation(classLocation == filesep) = '.';
                self.Results.testcase{self.TCNum}.ATTRIBUTE.classname = self.CurrentClass;
                self.Results.testcase{end}.ATTRIBUTE.name = component.Name;
            else
                self.CurrentClass = component.Name;
            end
            
%             if ~isa(component, 'TestCase')
%                 fprintf(self.FileHandle, '\n');
%             end
%             
%             fprintf(self.FileHandle, '%s%s', self.indentationSpaces(), component.Name);
%             
%             if ~isa(component, 'TestCase')
%                 fprintf(self.FileHandle, '\n');
%             else
%                 fprintf(self.FileHandle, ' %s ', self.leaderDots(component.Name));
%             end
        end    
            
        function testComponentFinished(self, component, did_pass)
            %testComponentFinished Update Command Window display

%             if ~isa(component, 'TestCase')
%                 fprintf(self.FileHandle, '%s%s %s ', self.indentationSpaces(), component.Name, ...
%                     self.leaderDots(component.Name));
%             end
%             
            component_run_time = toc(self.popTic());
            
            if isa(component, 'TestCase')
                
                self.Results.testcase{end}.ATTRIBUTE.time = component_run_time;
                
%                 if ~ did_pass
% %                     self.Results.testcase(end).failur
%                     
%                 end
            end
                
%             if did_pass
%                 fprintf(self.FileHandle, 'passed in %12.6f seconds\n', component_run_time);
%             else
%                 fprintf(self.FileHandle, 'FAILED in %12.6f seconds\n', component_run_time);
%             end
            
%             if ~isa(component, 'TestCase')
%                 fprintf(self.FileHandle, '\n');
%             end
%             
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
            %testRunFinished Update Command Window display
            %    obj.testRunFinished(component) displays information about the test
            %    run results, including any test failures, to the Command
            %    Window.
            
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
        
        function str = indentationSpaces(self)
            str = repmat(' ', 1, self.numIndentationSpaces());
        end
        
        function n = numIndentationSpaces(self)
            indent_level = numel(self.TicStack) - 1;
            n = 3 * indent_level;
        end
        
        function str = leaderDots(self, name)
            num_dots = max(0, 60 - self.numIndentationSpaces() - numel(name));
            str = repmat('.', 1, num_dots);
        end
        
    end
    
end
