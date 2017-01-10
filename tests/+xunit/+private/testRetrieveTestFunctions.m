%TESTRETRIEVETESTFUNCTIONS contains a test suite for xunit.private.testRetrieveTestFunctions

function testSuite = testRetrieveTestFunctions()
  testSuite = buildFunctionHandleTestSuite(localfunctions);
end

function testNoTestFiles()
  testList = getDefaultFunctionList();
  
  actual = xunit.private.retrieveTestFunctions(testList);
  
  expected = cell(0,1);
  assertEqual(expected, actual, ...
    'A list without any test functions should return an empty list.');
end

function testMultipleTestFiles()
  expected = {@testNoTestFiles; @testMultipleTestFiles};
  testList = [getDefaultFunctionList; expected];

  actual = xunit.private.retrieveTestFunctions(testList);
  
  assertEqual(expected, actual, ...
    'A list without any test functions should return an empty list.');
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
