function testSuite = testFunctionHandlesC
%testFunctionHandlesC Test file used by TestFunctionHandlesTest
%   Contains two passing tests that use a test fixture containing an intentional
%   error.

%   Steven L. Eddins
%   Copyright 2008 The MathWorks, Inc.

localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function testData = setUpFcn
testData = 5;

function testA(testData)
assertEqual(testData, 5);

function testB(testData)
assertEqual(testData, 5);

function tearDownFcn(testData)
% This assertion is expected to error.
assertEqual(testData, 20);
