function displayFault(file_handle, type, test_case, exception)
%xunit.displayFault Display test fault info to Command Window
%    xunit.displayFault() displays a summary of a test failure or
%    test error to the command window.

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

if strcmpi(type, 'failure')
    str = 'Failure';
else
    str = 'Error';
end

fprintf(file_handle, '\n===== Test Case %s =====\nLocation: %s\nName:     %s\n\n', str, ...
    test_case.Location, test_case.Name);
xunit.displayStack(xunit.filterStack(exception.stack), ...
    file_handle);
fprintf(file_handle, '\n%s\n', exception.message);

% Include more info on MultipleErrors
if strcmp(exception.identifier, 'MATLAB:MException:MultipleErrors')
    for i = 1:numel(exception.cause)
        fprintf(file_handle, 'Cause #%.0f:\t%s\n', i, exception.cause{i}.message);
    end
end

fprintf(file_handle, '\n');

end
