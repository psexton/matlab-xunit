%XUNIT.PRIVATE.RETRIEVESETUPFUNCTION retrieves the setup function from a list of function handles
%
% Description:
%   buildFunctionHandleTestSuite needs to retrieve the setup function from the
%   list of local function handles. retrieveSetupFunction does this retrieval.
%   If multiple functions qualify as a setup function, an exception is thrown.
%
% Syntax:
%   hSetupFunction = xunit.private.retrieveSetupFunction(hFunctions)
%
% Input:
%   hFunctions - cell array of function handles, possibly containing a function
%                handle to a valid setup function
%
% Output:
%   hSetupFunction - function handle to the setup function in the provided
%                    array of function handles.

function hSetupFunction = retrieveSetupFunction(hFunctions)
  functionNames = cellfun(@functionHandleToName, hFunctions, 'UniformOutput', false);
  isSetupFunction = xunit.utils.isSetUpString(functionNames);
  setupFunctions = hFunctions(isSetupFunction);
  if numel(setupFunctions) > 1
    error('findSubfunctionTests:tooManySetupFcns', ...
      'Found more than one setup subfunction.')
  elseif isempty(setupFunctions)
    hSetupFunction = [];
  else
    hSetupFunction = setupFunctions{1};
  end
end

function name = functionHandleToName(hFunc)
  name = getfield(functions(hFunc), 'function');
end
