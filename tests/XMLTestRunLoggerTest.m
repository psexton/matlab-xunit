%XMLTestRunLoggerTest Unit tests for XMLTestRunLogger

classdef XMLTestRunLoggerTest < TestCaseInDir
    properties (Access = private)
        % Remove files created using a test run
        performCleanup = true;
        testResultsFilename = fullfile(tempdir(), 'testResults.xml');
    end

    methods (Access = private)
        function exists = resultTargetExists(self)
            exists = (exist(self.testResultsFilename, 'file') == 2);
        end
    end

    methods
        function self = XMLTestRunLoggerTest(name)
            self = self@TestCaseInDir(name, ...
              fullfile(fileparts(mfilename('fullpath')), 'helper_classes'));
        end

        function setUp(self)
            % If a the result target exists at the start of the test run do not
            % remove it after the test run has finished to prevent the test
            % from removing files it shouldn't
            self.performCleanup = ~self.resultTargetExists();
        end

        function tearDown(self)
            if self.resultTargetExists() && self.performCleanup
                delete(self.testResultsFilename);
            end
        end

        function testLogsResultsToFilename(self)
            logger = XMLTestRunLogger(self.testResultsFilename);
            suite = TestSuite('TwoPassingTests');
            suite.run(logger);

            % The XMLTestRunLogger should have created the correct output file
            assertTrue(self.resultTargetExists());

            % And the resulting file should contain the correct results
            testResults = xml_read(self.testResultsFilename);
            assertEqual(testResults.ATTRIBUTE.tests, 2);
            assertEqual(testResults.ATTRIBUTE.errors, 0);
            assertEqual(testResults.ATTRIBUTE.failures, 0);
            assertEqual(testResults.ATTRIBUTE.skip, 0);
        end
    end
end
