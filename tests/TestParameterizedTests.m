%TestParameterizedTests Unit tests for sub-classing the TestSuite class.

classdef TestParameterizedTests < TestCaseInDir
    methods
        function self = TestParameterizedTests(name)
            self = self@TestCaseInDir(name, ...
                fullfile(fileparts(which(mfilename)), 'helper_classes'));
        end
        
        function testConstructor(~)
            % Exercise the constructor.  Verify that the Name and Location
            % properties are set correctly.
            ts = TestParameterizedSuite();
            assertEqual(ts.Name, 'TestParameterizedSuite');
            assertEqual(ts.Location, which('TestParameterizedSuite'));
            assertEqual(numel(ts.TestComponents), 3);
        end
        
        function testPassingTest(~)
            logger = TestRunLogger();
            suite = TestParameterizedSuite();
            tc = findTestComponent(suite, 'test_sin_0deg');
            tc.run(logger);
            assertEqual(logger.NumFailures, 0)
        end
        
        function testFailingTest(~)
            logger = TestRunLogger();
            suite = TestParameterizedSuite();
            tc = findTestComponent(suite, 'test_sin_90deg');
            tc.run(logger);
            assertEqual(logger.NumFailures, 1)
        end
    end
end

function theTestComponent = findTestComponent(suite, name)
% Find the TestComponent given a name of a function under test.

componentNames = cellfun(@(x) x.Name, suite.TestComponents, 'UniformOutput', false);
index = find(strcmp(name, componentNames), 1);
assertTrue(~ isempty(index), ['Could not find test component for ' name]);

theTestComponent = suite.TestComponents{index};

end
