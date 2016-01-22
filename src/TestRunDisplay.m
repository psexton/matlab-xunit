classdef TestRunDisplay < TestRunMonitor
%TestRunDisplay Print test suite execution results.
%   TestRunDisplay is a subclass of TestRunMonitor.  If a TestRunDisplay
%   object is passed to the run method of a TestComponent, such as a
%   TestSuite or a TestCase, it will print information to the Command
%   Window (or specified file handle) as the test run proceeds.
%
%   TestRunDisplay methods:
%       testComponentStarted  - Update Command Window display
%       testComponentFinished - Update Command Window display
%       testCaseFailure       - Log test failure information
%       testCaseError         - Log test error information
%
%   TestRunDisplay properties:
%       TestCaseCount         - Number of test cases executed
%       Faults                - Struct array of test fault info
%
%   See also TestRunLogger, TestRunMonitor, TestSuite

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.
    
    properties (SetAccess = private)
        %TestCaseCount - Number of test cases executed
        TestCaseCount
        
        %Faults - Struct array of test fault info
        %   Faults is a struct array with these fields:
        %       Type      - either 'failure' or 'error'
        %       TestCase  - the TestCase object that suffered the fault
        %       Exception - the MException thrown when the fault occurred
        Faults = struct('Type', {}, 'TestCase', {}, 'Exception', {});
        
    end
    
    properties (SetAccess = private, GetAccess = private)
        %InitialTic - Out of tic at beginning of test run
        InitialTic
        
        %InitialComponent First test component executed
        %   InitialComponent is set to the first test component executed in the
        %   test run.  This component is saved so that the end of the test run
        %   can be identified.
        InitialComponent = []   
        
    end
    
    properties (Access = protected)
        %FileHandle - Handle used by fprintf for displaying results.
        %             Default value of 1 displays to Command Window.
        FileHandle = 1
    end
        
    
    methods
        function self = TestRunDisplay(output)
            if nargin > 0
                if ischar(output)
                    self.FileHandle = fopen(output, 'w');
                    if self.FileHandle < 0
                        error('xunit:TestRunDisplay:FileOpenError', ...
                            'Could not open file "%s" for writing.', ...
                            filename);
                    end
                else
                    self.FileHandle = output;
                end
            end
        end
        
        function testComponentStarted(self, component)
            %testComponentStarted Update Command Window display
            %    If the InitialComponent property is not yet set, 
            %    obj.testComponentStarted(component) sets the property and calls
            %    obj.testRunStarted(component).
            
            if isempty(self.InitialComponent)
                self.InitialComponent = component;
                self.testRunStarted(component);
            end
        end    
            
        function testComponentFinished(self, component, did_pass)
            %testComponentFinished Update Command Window display
            %    If component is a TestCase object, then 
            %    obj.testComponentFinished(component, did_pass) prints pass/fail
            %    information to the Command Window.
            %
            %    If component is the InitialComponent, then
            %    obj.testRunFinished(did_pass) is called.
            
            if isa(component, 'TestCase')
                self.TestCaseCount = self.TestCaseCount + 1;
                if did_pass
                    fprintf(self.FileHandle, '.');
                else
                    fprintf(self.FileHandle, 'F');
                end
                line_length = 20;
                if mod(self.TestCaseCount, line_length) == 0
                    fprintf(self.FileHandle, '\n');
                end
            end
            
            if isequal(component, self.InitialComponent)
                self.testRunFinished(did_pass);
            end
        end
               
        function testCaseFailure(self, test_case, failure_exception)
            %testCaseFailure Log test failure information
            %    obj.testCaseFailure(test_case, failure_exception) logs the test
            %    case failure information.
            
            self.logFault('failure', test_case, ...
                failure_exception);
        end
        
        function testCaseError(self, test_case, error_exception)
            %testCaseError Log test error information
            %    obj.testCaseError(test_case, error_exception) logs the test
            %    case error information.
            
            self.logFault('error', test_case, ...
                error_exception);
        end
        
    end
    
    methods (Access = protected)
        function testRunStarted(self, component)
            %testRunStarted Update Command Window display
            %    obj.testRunStarted(component) displays information about the test
            %    run to the Command Window.
            
            self.InitialTic = tic;
            self.TestCaseCount = 0;
            num_cases = component.numTestCases();
            if num_cases == 1
                str = 'case';
            else
                str = 'cases';
            end
            fprintf(self.FileHandle, 'Starting test run with %d test %s.\n', ...
                num_cases, str);
        end
        
        function testRunFinished(self, did_pass)
            %testRunFinished Update Command Window display
            %    obj.testRunFinished(component) displays information about the test
            %    run results, including any test failures, to the Command Window.
            
            if did_pass
                result = 'PASSED';
            else
                result = 'FAILED';
            end
            
            fprintf(self.FileHandle, '\n%s in %.3f seconds.\n', result, toc(self.InitialTic));
            
            self.displayFaults();
        end
        

        
        function logFault(self, type, test_case, exception)
            %logFault Log test fault information
            %    obj.logFault(type, test_case, exception) logs test fault
            %    information. type is either 'failure' or 'error'. test_case is a
            %    TestCase object.  exception is an MException object.
            
            self.Faults(end + 1).Type = type;
            self.Faults(end).TestCase = test_case;
            self.Faults(end).Exception = exception;
        end
        
        function displayFaults(self)
            %displayFaults Display test fault info to Command Window
            %    obj.displayFaults() displays a summary of each test failure and
            %    test error to the command window.
            for k = 1:numel(self.Faults)
                faultData = self.Faults(k);
                xunit.displayFault(self.FileHandle, faultData.Type, faultData.TestCase, faultData.Exception);
            end
        end
        
    end
    
end
