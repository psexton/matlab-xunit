%XUNIT.PRIVATE.TESTRETRIEVESETUPFUNCTION contains a test suite for xunit.private.retrieveSetupFunction

function testSuite = testRetrieveSetupFunction()
  testSuite = buildFunctionHandleTestSuite(localfunctions);
end

function testNoSetupFunction()
  functionList = getDefaultFunctionList();
  
  actual = xunit.private.retrieveSetupFunction(functionList);
  
  assertEqual([], actual, ...
    'A list of function names without a setup function should return empty.');
 end

function testOneSetupFunction()
  functionList = [getDefaultFunctionList(); {@setup}];
  
  actual = xunit.private.retrieveSetupFunction(functionList);
  
  assertEqual(@setup, actual, ...
    'A list of function names with one setup function handle should that handle.');
end

function testMultipleSetupFunction()
  functionList = [getDefaultFunctionList(); {@setup; @setUp2}];
  
  hExceptFun = @() xunit.private.retrieveSetupFunction(functionList);
  
  assertExceptionThrown(hExceptFun, 'findSubfunctionTests:tooManySetupFcns', ...
    'A list of function names without a setup function should return empty.');
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
