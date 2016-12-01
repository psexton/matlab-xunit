% test_that.m is a subfunction test file.
function testSuite = test_that
testSuite = buildFunctionHandleTestSuite( ...
  cellfun(@str2func, which('-subfun', mfilename('fullpath')), ...
  'UniformOutput', false));

function test_the_other
a = magic(3);

function test_nifty
b = magic(5);
