function testSuite = notTestString
% This function exists to help test that the TestSuite.fromPwd() method does not
% pick up function-handle test files that do not match the naming convention.
testSuite = buildFunctionHandleTestSuite(localfunctions);

function testA

function testB


