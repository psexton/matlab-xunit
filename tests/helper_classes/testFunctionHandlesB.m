function testSuite = testFunctionHandlesB
%testFunctionHandlesB Test file used by TestFunctionHandlesTest
%   Contains two passing tests that use a test fixture.

%   Steven L. Eddins
%   Copyright 2008 The MathWorks, Inc.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function testData = setUpFcn
testData = 5;

function testA(testData)
assertEqual(testData, 5);

function testB(testData)
assertEqual(testData, 5);

function tearDownFcn(testData)
assertEqual(testData, 5);
