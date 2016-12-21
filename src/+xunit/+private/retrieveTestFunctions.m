%XUNIT.PRIVATE.RETRIEVETESTFUNCTIONS picks the handles to test functions from a list of function handles
%
% Description:
%   To build a test suite from an m file which has the test cases written as
%   local functions, `buildFunctionHandleTestSuite` needs to extract the actual
%   test functions from the list of function handles returned by, for instance,
%   `localfunctions`.
%
% Syntax:
%   hTestFunctions = xunit.private.retrieveTestFunctions(hFunctions)
%
% Input:
%   hFunctions - a cell array of function handles
%
% Output:
%   hTestFunctions - a cell array of all the function handles of the hFunctions
%                    that qualify as test functions.
%
% Example:
%   >> hTestFunctions = xunit.private.retrieveTestFunctions(localfunctions)

function hTestFunctions = retrieveTestFunctions(hFunctions)
  isTestFunctions = cellfun(@isaTestFunction, hFunctions);
  hTestFunctions = hFunctions(isTestFunctions);
end

function bool = isaTestFunction(hFunction)
  funcDetails = functions(hFunction);
  bool = xunit.utils.isTestString(funcDetails.function);
end
