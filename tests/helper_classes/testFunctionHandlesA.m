function testSuite = testFunctionHandlesA
%testFunctionHandlesA Test file used by TestFunctionHandlesTest
%   Contains two passing tests.

%   Steven L. Eddins
%   Copyright 2008 The MathWorks, Inc.

localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function testA

function testB
