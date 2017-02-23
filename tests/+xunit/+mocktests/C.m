% Class C is a TestSuite subclass containing two test cases (test_a and test_b).
classdef C < TestSuite
    methods
        function self = C()
            self = self@TestSuite();
            self.Name = class(self);
            self.Location = fileparts(which(class(self)));
            
            names = {'test_a'; 'test_b'};
            
            testCases = self.createTestCases(names);
            self.add(testCases);
        end
        
        function testCases = createTestCases(self, names)
            testCases = cell(1, size(names, 1));
            for idx = 1:size(names, 1)
                testCases{idx} = self.createTestCase(names{idx, 1});
            end
        end
        
        function testCase = createTestCase(self, name)
            %CREATETESTCASE Creates a function handle test case for a given test case
            
            % Create TestCase object
            testFcn     = @() [];
            setupFcn    = [];
            teardownFcn = [];
            
            testCase    = FunctionHandleTestCase(testFcn, setupFcn, teardownFcn);
            
            % Set name and location of test from name of file
            testCase.Name     = name;
            testCase.Location = which(class(self));
        end
    end
end
