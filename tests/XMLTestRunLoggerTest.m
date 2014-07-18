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
            % These tests use the TwoPassingTests suite helper class, so
            % the tests have to be executed in the context of the
            % helper_classes directory
            self = self@TestCaseInDir(name, ...
              fullfile(fileparts(mfilename('fullpath')), 'helper_classes'));
        end

        function setUp(self)
            % If the result target exists at the start of the test run do
            % not remove it after the run has finished to prevent the test
            % from removing files it shouldn't
            self.performCleanup = ~self.resultTargetExists();

            % Call the setUp method on the parent class to set up the
            % environment such that the TwoPassingTests suite can be found
            setUp@TestCaseInDir(self);
        end

        function tearDown(self)
            % Call the tearDown method on the parent class to restore the
            % environment to the state it was in before running the test
            tearDown@TestCaseInDir(self);

            if self.resultTargetExists() && self.performCleanup
                delete(self.testResultsFilename);
            end
        end

        function testLogsResultsToFileIdentifier(self)
            fileIdentifier = fopen(self.testResultsFilename, 'w');
            fileCloser = onCleanup(@() fclose(fileIdentifier));

            logger = XMLTestRunLogger(fileIdentifier);
            suite = TestSuite('TwoPassingTests');
            suite.run(logger);

            % The XMLTestRunLogger should have created the output file
            assertTrue(self.resultTargetExists());

            % And the resulting file should contain the correct results
            testResults = xml_read(self.testResultsFilename);
            assertEqual(testResults.ATTRIBUTE.tests, 2);
            assertEqual(testResults.ATTRIBUTE.errors, 0);
            assertEqual(testResults.ATTRIBUTE.failures, 0);
            assertEqual(testResults.ATTRIBUTE.skip, 0);
        end

        function testLogsResultsToFilename(self)
            logger = XMLTestRunLogger(self.testResultsFilename);
            suite = TestSuite('TwoPassingTests');
            suite.run(logger);

            % The XMLTestRunLogger should have created the output file
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
