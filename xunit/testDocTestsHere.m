function test_suite = testDocTestsHere
% Put this function in any directory to make its doctests visible
%
% This function constructs an xUnit TestSuite that contains all the
% doctests it can find in this directory.  It does not include
% subdirectories.
%
% Once this file is there, you can run 'runtests' in this directory, or if
% you're somewhere else, 'runtests /path/to/this/dir'.
%

test_suite = TestSuite();
test_suite.Name = ['DocTests at ' pwd];
test_suite.Location = pwd;

mfiles = dir(fullfile('.', '*.m'));
for k = 1:numel(mfiles)
    [path, name] = fileparts(mfiles(k).name);
    this_suite = DocTestSuite(name);
    if this_suite.numTestCases > 0
        test_suite.add(this_suite);
    end
end
