function displayFault(file_handle, type, test_case, exception)
%displayFault Display test fault info to Command Window
%    displayFault() displays a summary of a test failure or
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
displayStack(filterStack(exception.stack), ...
    file_handle);
fprintf(file_handle, '\n%s\n', exception.message);

fprintf(file_handle, '\n');

end
