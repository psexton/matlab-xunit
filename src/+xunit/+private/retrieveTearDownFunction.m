%XUNIT.PRIVATE.RETRIEVETEARDOWNFUNCTION retrieves the tear down function from a list of function handles
%
% Description:
%   buildFunctionHandleTestSuite needs to retrieve the tear down function from
%   the list of local function handles. retrieveSetupFunction does this
%   retrieval. If multiple functions qualify as a setup function, an exception
%   is thrown.
%
% Syntax:
%   hTearDownFunction = xunit.private.retrieveTearDownFunction(hFunctions)
%
% Input:
%   hFunctions - cell array of function handles, possibly containing a function
%                handle to a valid tear down function
%
% Output:
%   hTearDownFunction - function handle to the tear down function in the
%                       provided array of function handles.

function hTearDownFunction = retrieveTearDownFunction(hFunctions)
  functionNames = cellfun(@functionHandleToName, hFunctions, 'UniformOutput', false);
  isTearDownFunction = xunit.utils.isTearDownString(functionNames);
  tearDownFunctions = hFunctions(isTearDownFunction);
  if numel(tearDownFunctions) > 1
    error('findSubfunctionTests:tooManyTearDownFcns', ...
      'Found more than one teardown subfunction.')
  elseif isempty(tearDownFunctions)
    hTearDownFunction = [];
  else
    hTearDownFunction = tearDownFunctions{1};
  end
end

function name = functionHandleToName(hFunc)
  name = getfield(functions(hFunc), 'function');
end
