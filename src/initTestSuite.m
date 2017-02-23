feedback = {
    'xunit:initTestSuite:deprecatedSyntax', ...
    ['Starting with MATLAB R2016b, `initTestSuite` can no longer be ' ...
    'called without input arguments due to the way scripts are scoped from ' ...
    'that version onwards. The function `buildFunctionHandleTestSuite` can ' ...
    'be used as an alternative. See its help for usage instructions.\n\nThe ' ...
    '`initTestSuite` script will be removed in the next major release.']
    };

matlabVersionInfo = ver('matlab');
if str2double(matlabVersionInfo.Version) >= 9.1 % R2016b and later
    error(feedback{:});
else
    warning(feedback{:});
    
    [ST,I] = dbstack('-completenames');
    callerFile = ST(I + 1).file;
    subFunctionNames = which('-subfun', callerFile);
    localFunctionHandles = cellfun(@str2func, subFunctionNames, 'UniformOutput', false);
    test_suite = buildFunctionHandleTestSuite(localFunctionHandles, ~nargout);
end
