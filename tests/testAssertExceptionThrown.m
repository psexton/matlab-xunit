function testSuite = testAssertExceptionThrown
%testAssertExceptionThrown Unit tests for assertExceptionThrown

%   Steven L. Eddins
%   Copyright 2008 The MathWorks, Inc.

localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function test_happyCase
assertExceptionThrown(...
    @() error('MyProd:MyFun:MyId', 'my message'), 'MyProd:MyFun:MyId');

function test_wrongException
assertExceptionThrown(@() assertExceptionThrown(...
    @() error('MyProd:MyFun:MyId', 'my message'), ...
    'MyProd:MyFun:DifferentId'), 'assertExceptionThrown:wrongException');

function test_noException
assertExceptionThrown(@() assertExceptionThrown(@() sin(pi), 'foobar'), ...
    'assertExceptionThrown:noException');



