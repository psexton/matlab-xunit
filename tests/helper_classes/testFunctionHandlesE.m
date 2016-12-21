function testSuite = testFunctionHandlesE
%testFunctionHandlesE Test file used by TestFunctionHandlesTest
%   Contains one failing test.

%   Steven L. Eddins
%   Copyright 2008 The MathWorks, Inc.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function testA
error('testFunctionHandlesA:expectedFailure', 'Bogus message');

