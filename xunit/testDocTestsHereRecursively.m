function test_suite = testDocTestsHereRecursively
% Put this function in a directory to make doctests under it visible
%
% This function constructs an xUnit TestSuite that contains all the
% doctests it can find in this directory and all subdirectories.
%
% Once this file is there, you can run 'runxunit' in this directory, or if
% you're somewhere else, 'runxunit /path/to/this/dir'.
%

% Copyright 2010-2011 Thomas Grenfell Smith

test_suite = TestSuite();
test_suite.Name = ['DocTests under ' pwd];
test_suite.Location = pwd;

directories = walk_dirs(pwd);
for D = 1:numel(directories)
    this_dir = directories{D};
    
    mfiles = dir(fullfile(this_dir, '*.m'));
    for k = 1:numel(mfiles)
        [path, name] = fileparts(mfiles(k).name);
        
        % Ensure that we'll test the function that we're trying to
        callable_path = fileparts(which(name));
        if ~ strcmp(callable_path, this_dir)
            fprintf('Would get %s from %s when you wanted %s\n', ...
                name, callable_path, this_dir);
            error('You seem to be testing files that aren''t on the path');
        end
        this_suite = DocTestSuite(name);
        if this_suite.numTestCases > 0
            test_suite.add(this_suite);
        end
    end
end

end

function dir_list = walk_dirs(d)
%WALK_DIRS Recursively walk a directory, returning it and subdirectories
%   This is a version of GENPATH, modified by Thomas Smith to leave out
%   directories starting with '.', so it avoids .svn directories for
%   instance.  It returns a cell array of paths, rather than a
%   colon-separated string.

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 1.13.4.4 $ $Date: 2006/10/14 12:24:02 $
%------------------------------------------------------------------------------

if nargin==0,
  error('I require a directory to walk!');
  return
end

% initialise variables
methodsep = '@';  % qualifier for overloaded method directories
% p = '';           % path to be returned
dir_list = {};

% Generate path based on given root directory
files = dir(d);
if isempty(files)
  return
end

% Add d to the path even if it is empty.
% p = [p d pathsep];
dir_list = [dir_list {d}];

% set logical vector for subdirectory entries in d
isdir = logical(cat(1,files.isdir));
%
% Recursively descend through directories which are neither
% private nor "class" directories.
%
dirs = files(isdir); % select only directory entries from the current listing


% modified: any dir starting with '.' is left out.
for i=1:length(dirs)
   dirname = dirs(i).name;
   if    ~strncmp( dirname,'.',1) && ...
         ~strncmp( dirname,methodsep,1) && ...
         ~strcmp( dirname,'private')
%       p = [p walk_dirs(fullfile(d,dirname))]; % recursive calling of this function.
      dir_list = [dir_list walk_dirs(fullfile(d,dirname))];
   end
end

%------------------------------------------------------------------------------

end