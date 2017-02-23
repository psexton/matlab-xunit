function out = runxunit(varargin)
%runxunit Run unit tests
%   runxunit runs all the test cases that can be found in the current directory
%   and summarizes the results in the Command Window.
%
%   Test cases can be found in the following places in the current directory:
%
%       * An M-file function whose name starts or ends with "test" or
%         "Test" and that returns no output arguments.
%
%       * An M-file function whose name starts or ends with "test" or
%         "Test" and that contains subfunction tests and uses the
%         buildFunctionHandleTestSuite function to return a TestSuite object.
%
%       * An M-file defining a subclass of TestCase.
%
%   runxunit(dirname) runs all the test cases found in the specified directory.
%
%   runxunit(packagename) runs all the test cases found in the specified
%   package. (This option requires R2009a or later).
%
%   runxunit(mfilename) runs test cases found in the specified function or class
%   name. The function or class needs to be in the current directory or on the
%   MATLAB path.
%
%   runxunit('mfilename:testname') runs the specific test case named 'testname'
%   found in the function or class 'name'.
%
%   Multiple directories or file names can be specified by passing multiple
%   names to runxunit, as in runxunit(name1, name2, ...) or
%   runxunit({name1, name2, ...}, ...)
%
%   runxunit(..., '-verbose') displays the name and result, result, and time
%   taken for each test case to the Command Window.
%
%   runxunit(..., '-logfile', filename) directs the output of runxunit to
%   the specified log file instead of to the Command Window.
%
%   runxunit(..., '-xmlfile', filename) directs the output of runxunit to
%   the specified xUnit-formatted XML log file instead of to the Command
%   Window.  This format is compatible with JUnit, and can be read by many
%   tools.
%
%   out = runxunit(...) returns a logical value that is true if all the
%   tests passed.
%
%   Examples
%   --------
%   Find and run all the test cases in the current directory.
%
%       runxunit
%
%   Find and run all the test cases in the current directory. Display more
%   detailed information to the Command Window as the test cases are run.
%
%       runxunit -verbose
%
%   Save verbose runxunit output to a log file.
%
%       runxunit -verbose -logfile my_test_log.txt
%
%   Find and run all the test cases contained in the M-file myfunc.
%
%       runxunit myfunc
%
%   Find and run all the test cases contained in the TestCase subclass
%   MyTestCase.
%
%       runxunit MyTestCase
%
%   Run the test case named 'testFeature' contained in the M-file myfunc.
%
%       runxunit myfunc:testFeature
%
%   Run all the tests in a specific directory.
%
%       runxunit c:\Work\MyProject\tests
%
%   Run all the tests in two directories.
%
%       runxunit c:\Work\MyProject\tests c:\Work\Book\tests

%   Steven L. Eddins
%   Copyright 2009-2010 The MathWorks, Inc.

verbose = false;
logfile = '';
isxml = false;
if nargin < 1
    suite = TestSuite.fromPwd();
else
    [name_list, verbose, logfile, isxml] = getInputNames(varargin{:});
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
    error('xunit:runxunit:noTestCasesFound', 'No test cases found.');
end

if ~isxml
    if isempty(logfile)
        logfile_handle = 1; % File handle corresponding to Command Window
    else
        logfile_handle = fopen(logfile, 'w');
        if logfile_handle < 0
            error('xunit:runxunit:FileOpenFailed', ...
                'Could not open "%s" for writing.', logfile);
        else
            cleanup = onCleanup(@() fclose(logfile_handle));
        end
    end
    
    fprintf(logfile_handle, 'Test suite: %s\n', suite.Name);
    if ~strcmp(suite.Name, suite.Location)
        fprintf(logfile_handle, 'Test suite location: %s\n', suite.Location);
    end
    fprintf(logfile_handle, '%s\n\n', datestr(now));
end

if isxml
    monitor = XMLTestRunLogger(logfile);
elseif verbose
    monitor = VerboseTestRunDisplay(logfile_handle);
else
    monitor = TestRunDisplay(logfile_handle);
end
did_pass = suite.run(monitor);

if nargout > 0
    out = did_pass;
end

function [name_list, verbose, logfile, isxml] = getInputNames(varargin)
name_list = {};
verbose = false;
logfile = '';
isxml = false;
k = 1;
while k <= numel(varargin)
    arg = varargin{k};
    if iscell(arg)
        name_list = [name_list; arg]; %#ok<AGROW>
    elseif ~isempty(arg) && (arg(1) == '-')
        if strcmp(arg, '-verbose')
            verbose = true;
        elseif strcmp(arg, '-logfile')
            if k == numel(varargin)
                error('xunit:runxunit:MissingLogfile', ...
                    'The option -logfile must be followed by a filename.');
            else
                logfile = varargin{k+1};
                k = k + 1;
            end
        elseif strcmp(arg, '-xmlfile')
            if k == numel(varargin)
                error('xunit:runxunit:MissingXMLfile', ...
                    'The option -xmlfile must be followed by a filename.');
            else
                isxml = true;
                logfile = varargin{k+1};
                k = k + 1;
            end
        else
            warning('runxunit:unrecognizedOption', 'Unrecognized option: %s', arg);
        end
    else
        name_list{end+1} = arg; %#ok<AGROW>
    end
    k = k + 1;
end
