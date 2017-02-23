classdef TestParameterizedSuite < TestSuite
    methods
        function this = TestParameterizedSuite()
            this = this@TestSuite();
            this.Name = class(this);
            this.Location = which(class(this));
            
            values = {0, 0; 30 0.5; 90 0.8};
            
            testCases = this.createTestCases(values);
            this.add(testCases);
        end
        
        function testCases = createTestCases(this, values)
            testCases = cell(1, size(values, 1));
            for idx = 1:size(values, 1)
                testCases{idx} = this.createTestCase(values{idx, 1}, values{idx, 2});
            end
        end
        
        function testCase = createTestCase(this, x, y)
            %CREATETESTCASE Creates a function handle test case for a given test case
            
            % Create TestCase object
            testFcn     = @() TestParameterizedSuite.checkResult(x, y);
            setupFcn    = [];
            teardownFcn = [];
            
            testCase    = FunctionHandleTestCase(testFcn, setupFcn, teardownFcn);
            
            % Set name and location of test from name of file
            testCase.Name     = this.makeTestName(x);
            testCase.Location = this.Location;
        end
        function str = makeTestName(this, x) %#ok<MANU>
            str = sprintf('test_sin_%.0fdeg', x);
            str = genvarname(str);
        end
    end
    
    methods (Static)
        function checkResult(x, y)
            assertElementsAlmostEqual(sind(x), y, 'absolute', 1e-9)
        end
    end
end
