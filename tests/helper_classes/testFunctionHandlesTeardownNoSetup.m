function testSuite = testFunctionHandlesTeardownNoSetup
% Verify that test file works if it has a teardown function but no setup
% function.
testSuite = buildFunctionHandleTestSuite(localfunctions);

function teardown
close all

function test_normalCase
assertEqual(1, 1);

