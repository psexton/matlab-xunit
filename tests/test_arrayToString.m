function testSuite = test_arrayToString
%test_arrayToString Unit test for arrayToString.

%   Steven L. Eddins
%   Copyright 2009 The MathWorks, Inc.

localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function test_smallInput
A = [1 2 3];
assertEqual(strtrim(xunit.utils.arrayToString(A)), '1     2     3');

function test_largeInput
A = zeros(1000, 1000);

% The way `disp` visualizes 'times' has changed in R2016b and onwards, so the
% test needs to be a bit more flexible
assertTrue(xunit.utils.containsRegexp('[1000.1000 double]', ...
                                      xunit.utils.arrayToString(A)));

function test_emptyInput
% The way `disp` visualizes 'times' has changed in R2016b and onwards, so the
% test needs to be a bit more flexible
assertTrue(xunit.utils.containsRegexp('[1.0.2 double]', ...
                                      xunit.utils.arrayToString(zeros(1,0,2))));
