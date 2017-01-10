function testSuite = notTestString
% This function exists to help test that the TestSuite.fromPwd() method does not
% pick up function-handle test files that do not match the naming convention.
localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function testA

function testB


