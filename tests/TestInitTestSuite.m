classdef TestInitTestSuite < TestCase
  methods (Static, Access = private)
    function version = getDecimalMatlabVersion()
      version = xunit.private.getDecimalMatlabVersion();
    end

    function cleanupHandle = moveToTestDir()
      startDir = cd(fullfile(fileparts(mfilename('fullpath')), 'initTestSuiteTest'));
      cleanupHandle = onCleanup(@() cd(startDir));
    end
  end

  methods (Access = private)
    function assertSuccessfulTestSuiteExecution(obj, command)
      cleanupHandle = obj.moveToTestDir();

      testRunOutput = evalc(command);

      expectedString = 'Warning: Starting with MATLAB R2016b';
      % Cannot use exact matching here as `warning` generates 'invisible' color
      % codes at the start of the output
      containsWarning = ~isempty(strfind(testRunOutput, expectedString));
      assertTrue(containsWarning, ...
        'Expected test run output to contain a usage warning about initTestSuite');

      % The test suites have 1 passing and 1 failing test, the output should
      % reflect this, including the correct failure message
      matcher = 'with 2 test cases.\n\.F\nFAILED.+Asserted condition is not true';
      containsTestSuiteResults = ~isempty(regexp(testRunOutput, ...
        matcher, 'once'));
      assertTrue(containsTestSuiteResults, sprintf( ...
        ['Expected test run output to contain the proper suite results. ' ...
         'Expected \n%s\n to match regular expression \n%s\n'], ...
        testRunOutput, matcher));
    end
  end

  methods
    function obj = TestInitTestSuite(name)
      obj = obj@TestCase(name);
    end

    function testErrorsOn2016bAndLater(obj)
      if obj.getDecimalMatlabVersion() >= 9.1
        cleanupHandle = obj.moveToTestDir();

        assertExceptionThrown(@() initTestSuiteTest, ...
          'xunit:initTestSuite:deprecatedSyntax');
      end
    end

    function testPackagedTestSuiteBefore2016b(obj)
      matlabVersion = obj.getDecimalMatlabVersion();
      if matlabVersion < 9.1
        obj.assertSuccessfulTestSuiteExecution('packaged.initTestSuiteTest();')
      end
    end

    function testUnpackagedTestSuiteBefore2016b(obj)
      matlabVersion = obj.getDecimalMatlabVersion();
      if matlabVersion < 9.1
        obj.assertSuccessfulTestSuiteExecution('packaged.initTestSuiteTest();')
      end
    end
  end
end
