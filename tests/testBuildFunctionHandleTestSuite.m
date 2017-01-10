%TESTBUILDFUNCTIONHANDLETESTSUITE contains a test suite for buildFunctionHandleTestSuite

function testSuite = testBuildFunctionHandleTestSuite()
  testSuite = buildFunctionHandleTestSuite(localfunctions);
end

function testBuildSuiteNoTests()
  defaultList = getDefaultFunctionList();

  testSuite = buildFunctionHandleTestSuite(defaultList);

  assertEqual(0, numel(testSuite.TestComponents), ...
    'An m-file with no test functions should result in a TestSuite with no tests.');
end

function testBuildSuiteWithTests()
  defaultList = getDefaultFunctionList();
  testList = {@emptyTest; @testAtTheStart};
  funcList = [defaultList; testList];

  testSuite = buildFunctionHandleTestSuite(funcList);

  assertEqual(2, numel(testSuite.TestComponents), ...
    'An m-file with 2 test functions should result in a TestSuite with 2 tests.');
end

function testBuildSuiteWithSetup()
  defaultList = getDefaultFunctionList();
  testList = {@emptyTest};
  setupList = {@setup};
  funcList = [defaultList; setupList; testList];

  testSuite = buildFunctionHandleTestSuite(funcList);
  hExceptionCall = @() testSuite.TestComponents{1}.setUp;

  assertExceptionThrown(hExceptionCall, 'xunit:setup:called', ...
    'The setup function is not called');
end

function testBuildSuiteWithTearDown()
  defaultList = getDefaultFunctionList();
  testList = {@emptyTest};
  tearDownList = {@teardown};
  funcList = [defaultList; tearDownList; testList];

  testSuite = buildFunctionHandleTestSuite(funcList);
  hExceptionCall = @() testSuite.TestComponents{1}.tearDown;

  assertExceptionThrown(hExceptionCall, 'xunit:teardown:called', ...
    'The tear down function is not called');
end

function testRunTestsOnRequest()
  defaultList = getDefaultFunctionList();
  testList = {@runTest};
  funcList = [defaultList; testList]; %#ok<NASGU>

  persistValue('testSuiteDidNotRun');
  % Suppress output from running the test suite
  evalc('testSuite = buildFunctionHandleTestSuite(funcList, true)');
  actual = persistValue();

  expected = 'testSuiteHasRun';
  assertEqual(expected, actual, ...
    'If no output arguments are requested, the test suite should be run.');
end

function testRunTestsIfNoOutputRequested()
  defaultList = getDefaultFunctionList();
  testList = {@runTest};
  funcList = [defaultList; testList]; %#ok<NASGU>

  persistValue('testSuiteDidNotRun');
  % Suppress output from running the test suite
  evalc('buildFunctionHandleTestSuite(funcList)');
  actual = persistValue();

  expected = 'testSuiteHasRun';
  assertEqual(expected, actual, ...
    'If no output arguments are requested, the test suite should be run.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper functions

function basicList = getDefaultFunctionList()
  basicList = {
    @foo
    @bar
    @camelCase
  };
end

% Bogus functions

function foo
end

function bar
end

function camelCase
end
