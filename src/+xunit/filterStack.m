function new_stack = filterStack(stack)
%xunit.filterStack Remove unmeaningful stack trace calls
%    new_stack = xunit.filterStack(stack) removes from the input stack trace calls
%    that are framework functions and methods that are not likely to be
%    meaningful to the user.

%   Steven L. Eddins
%   Copyright 2008-2010 The MathWorks, Inc.

% Testing stack traces follow this common pattern:
%
% 1. The first function call in the trace is often one of the assert functions
% in the framework directory.  This is useful to see.
%
% 2. The next function calls are in the user-written test functions/methods and
% the user-written code under test.  These calls are useful to see.
%
% 3. The final set of function calls are methods in the various framework
% classes.  There are usually several of these calls, which clutter up the
% stack display without being that useful.
%
% The pattern above suggests the following stack filtering strategy: Once the
% stack trace has left the framework directory, do not follow the stack trace back
% into the framework directory.

mtest_directory = fileparts(which('runxunit'));
last_keeper = numel(stack);
have_left_mtest_directory = false;
for k = 1:numel(stack)
    directory = fileparts(stack(k).file);
    if have_left_mtest_directory
        if strcmp(directory, mtest_directory)
            % Stack trace has reentered mtest directory.
            last_keeper = k - 1;
            break;
        end
    else
        if ~strcmp(directory, mtest_directory)
            have_left_mtest_directory = true;
        end
    end
end

new_stack = stack(1:last_keeper);

end
