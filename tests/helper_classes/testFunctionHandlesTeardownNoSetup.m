function testSuite = testFunctionHandlesTeardownNoSetup
% Verify that test file works if it has a teardown function but no setup
% function.
localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function teardown
close all

function test_normalCase
assertEqual(1, 1);

