%BUILDFUNCTIONHANDLETESTSUITE builds a test suite from a set of function handles
%
% Description:
%   Builds a test suite from a set of function handles. These should be named
%   according to xUnit's naming convention and can include setUp and tearDown
%   functions which will be handled accordingly.
%
%   If no output arguments are requested, or if the optional input flag is
%   specified, the generated test suite is run before returning.
%
% Syntax:
%   testSuite = buildFunctionHandleTestSuite(functionHandles, { runImmediately })
%
% Input:
%   functionHandles - a cell array of function handles, typically acquired by
%                     calling `localfunctions` in a file with sub functions
%                     defining a test suite
%
% Optional Input:
%   runImmediately - a boolean indicating whether to run the test suite as soon
%                    as it has been build
%
% Optional Output:
%   testSuite - the generated test suite if requested. When not requested the
%               generated test suite is executed immediately
%
% Examples:
%   % Build and execute the test suite defined by a set of function handles
%   >> buildFunctionHandleTestSuite(localfunctions)
%
%   % Build a test suite defined by a set of function handles
%   >> testSuite = buildFunctionHandleTestSuite(localfunctions)
%
%   % Run the generated test suite immediately when run in 'interactive' mode,
%   % i.e. when F5 is pressed to execute the file defining the tests as
%   % subfunctions. Note that nargout can only be used inside functions! This
%   % will not work from the command line, although passing any other variable
%   % evaluating to a boolean would
%   >> testSuite = buildFunctionHandleTestSuite(localfunctions, ~nargout)
%
%   % On versions prior to R2014b, `localfunctions` does not properly detect or
%   % does not even exist _at all_. In these situations a cell array of
%   % function handles can be obtained using
%   >> localFunctionHandles = cellfun(@str2func, ...
%        which('-subfun', mfilename('fullpath')), 'UniformOutput', false));
%   >> testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function testSuite = buildFunctionHandleTestSuite(hLocalFunctions, runImmediately)
hSetupFunction = xunit.private.retrieveSetupFunction(hLocalFunctions);
hTearDownFunction = xunit.private.retrieveTearDownFunction(hLocalFunctions);
hTestFunctions = xunit.private.retrieveTestFunctions(hLocalFunctions);

[callerName, callerFile] = getCallerData();
testSuite = TestSuite();
testSuite.Name = callerName;
testSuite.Location = which(callerFile);
for k = 1:numel(hTestFunctions)
    testSuite.add(FunctionHandleTestCase(hTestFunctions{k}, ...
        hSetupFunction, hTearDownFunction));
end

if nargout == 0 || (nargin > 1 && runImmediately)
    testSuite.run();
end
end

function [callerName, callerFile] = getCallerData()
[ST,I] = dbstack('-completenames');

if numel(ST) <= 2
    throwAsCaller(MException('xunit:buildFunctionHandleTestSuite:invalidCallingSyntax', ...
        'This function must be called from within another function'));
end

% TODO: The first branch here exists to accomodate backwards compatibility
% with the initTestSuite script approach which worked prior to MATLAB R2016b.
% It can be removed once support for this syntax is dropped, otherwise the
% names to the local functions cannot be found as the wrong file is checked
if strcmp(ST(I + 2).name, 'initTestSuite')
    callerFile = ST(I + 3).file;
    callerName = ST(I + 3).name;
else
    callerFile = ST(I + 2).file;
    callerName = ST(I + 2).name;
end
end
