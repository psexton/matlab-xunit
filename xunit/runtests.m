function out = runtests(varargin)
%runtests Run unit tests
%   runtests runs all the test cases that can be found in the current directory
%   and summarizes the results in the Command Window.
%
%   Test cases can be found in the following places in the current directory:
%
%       * An M-file function whose name starts or ends with "test" or
%         "Test" and that returns no output arguments.
%
%       * An M-file function whose name starts or ends with "test" or
%         "Test" and that contains subfunction tests and uses the
%         initTestSuite script to return a TestSuite object.
%
%       * An M-file defining a subclass of TestCase.
%
%   runtests(dirname) runs all the test cases found in the specified directory.
%
%   runtests(packagename) runs all the test cases found in the specified
%   package.
%
%   runtests(mfilename) runs test cases found in the specified function or class
%   name. The function or class needs to be in the current directory or on the
%   MATLAB path.
%
%   runtests('mfilename:testname') runs the specific test case named 'testname'
%   found in the function or class 'name'.
%
%   Multiple directories or file names can be specified by passing multiple
%   names to runtests, as in runtests(name1, name2, ...). 
%
%   runtests(..., '-verbose') displays the name and result, result, and time
%   taken for each test case to the Command Window.
%
%   out = runtests(...) returns a logical value that is true if all the
%   tests passed.
%
%   Examples
%   --------
%   Find and run all the test cases in the current directory.
%
%       runtests
%
%   Find and run all the test cases in the current directory. Display more
%   detailed information to the Command Window as the test cases are run.
%
%       runtests -verbose
%
%   Find and run all the test cases contained in the M-file myfunc.
%
%       runtests myfunc
%
%   Find and run all the test cases contained in the TestCase subclass
%   MyTestCase.
%
%       runtests MyTestCase
%
%   Run the test case named 'testFeature' contained in the M-file myfunc.
%
%       runtests myfunc:testFeature
%
%   Run all the tests in a specific directory.
%
%       runtests c:\Work\MyProject\tests
%
%   Run all the tests in two directories.
%
%       runtests c:\Work\MyProject\tests c:\Work\Book\tests

%   Steven L. Eddins
%   Copyright 2009-2010 The MathWorks, Inc.

verbose = false;
if nargin < 1
    suite = TestSuite.fromPwd();
else
    [name_list, verbose] = getInputNames(varargin{:});
    if numel(name_list) == 0
        suite = TestSuite.fromPwd();
    elseif numel(name_list) == 1
        suite = TestSuite.fromName(name_list{1});
    else
        suite = TestSuite();
        for k = 1:numel(name_list)
            suite.add(TestSuite.fromName(name_list{k}));
        end
    end
end

if isempty(suite.TestComponents)
    error('xunit:runtests:noTestCasesFound', 'No test cases found.');
end

if verbose
    monitor = VerboseCommandWindowTestRunDisplay();
else
    monitor = CommandWindowTestRunDisplay();
end
did_pass = suite.run(monitor);

if nargout > 0
    out = did_pass;
end

function [name_list, verbose] = getInputNames(varargin)
name_list = {};
verbose = false;
for k = 1:numel(varargin)
    name = varargin{k};
    if ~isempty(name) && (name(1) == '-')
        if strcmp(name, '-verbose')
            verbose = true;
        else
            warning('runtests:unrecognizedOption', 'Unrecognized option: %s', name);
        end
    else
        name_list{end+1} = name;
    end
end
    
