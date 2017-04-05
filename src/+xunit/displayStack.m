function displayStack(stack, file_handle)
%xunit.displayStack Display stack trace from MException instance
%   xunit.displayStack(stack) prints information about an exception stack to the
%   command window.

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

if nargin < 2, file_handle = 1; end

command_line_mode = ~ usejava('desktop');

for k = 1:numel(stack)
    filename = stack(k).file;
    linenumber = stack(k).line;
    if command_line_mode
        fprintf(file_handle, '%s at line %d\n', filename, linenumber);
    else
        href = sprintf('matlab: opentoline(''%s'',%d)', filename, linenumber);
        fprintf(file_handle, '%s at <a href="%s">line %d</a>\n', filename, href, linenumber);
    end
end
end
