%XUNIT.PRIVATE.TESTRETRIEVESETUPFUNCTION contains a test suite for xunit.private.retrieveTearDownFunction

function testSuite = testRetrieveTearDownFunction()
  testSuite = buildFunctionHandleTestSuite(localfunctions);
end

function testNoTearDownFunction()
  functionList = getDefaultFunctionList();
  
  actual = xunit.private.retrieveTearDownFunction(functionList);
  
  assertEqual([], actual, ...
    'A list of function names without a tear down function should return empty.');
 end

function testOneTearDownFunction()
  functionList = [getDefaultFunctionList(); {@tearDown}];
  
  actual = xunit.private.retrieveTearDownFunction(functionList);
  
  assertEqual(@tearDown, actual, ...
    'A list of function names with one setup function handle should that handle.');
end

function testMultipleTearDownFunction()
  functionList = [getDefaultFunctionList(); {@tearDown; @tearDown2}];
  
  hExceptFun = @() xunit.private.retrieveTearDownFunction(functionList);
  
  assertExceptionThrown(hExceptFun, 'findSubfunctionTests:tooManyTearDownFcns', ...
    'A list of function names with multiple tear down functions should throw an exception.');
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
