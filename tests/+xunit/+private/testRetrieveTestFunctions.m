%TESTRETRIEVETESTFUNCTIONS contains a test suite for xunit.private.testRetrieveTestFunctions

function testSuite = testRetrieveTestFunctions()
  localFunctionHandles = cellfun(@str2func, ...
    which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
  testSuite = buildFunctionHandleTestSuite(localFunctionHandles);
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
