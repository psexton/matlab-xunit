function testSuite = testFunctionHandlesE
%testFunctionHandlesE Test file used by TestFunctionHandlesTest
%   Contains one failing test.

%   Steven L. Eddins
%   Copyright 2008 The MathWorks, Inc.

localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function testA
error('testFunctionHandlesA:expectedFailure', 'Bogus message');

