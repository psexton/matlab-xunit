%% <../index.html MATLAB xUnit Test Framework>: Compatibility with R2016b
% Significant changes were made to MATLAB in R2016b that affect how xUnit 
% works. If you wrote tests using version 4.0.0 or earlier, you may need
% to make slight changes to your tests to make them work on 2016b and 
% subsequent releases.
% 
% An incredible amount of effort was expended trying to find a solution that 
% would allow all existing tests to continue to run on 2016b and on previous versions, 
% with no changes, but we don't believe that to be possible. (Although you 
% are welcome to try, and submit a pull request if you succeed.)
% 
% Listed below are the different scenarios you may be in, and what to do 
% about it.

%% I use class-based tests
% My tests start like this:

dbtype examples_2016b_compatibility/TestUsingClasses.m 1

%%
% Five points for using classes! You can stop reading now. You're not affected.

%% I use function-based tests
% My tests start like this:

dbtype examples_2016b_compatibility/testUsingFunctionsDeprecated.m 1:2

%% 
% The way this worked is that |inittestsuite| was actually a script, called 
% from within the scope of your test function. And as a result of that, it
% had access to all the subfunctions that were your actual tests, and was
% able to build a test suite that way. Starting with 2016b, scripts called
% from functions no longer have access to the caller's scope, and this
% strategy will not (can not) work.
%
% The replacement is to construct a test suite out of function handles, 
% while still in the scope of |testUsingFunctionsDeprecated|. In 2014b and 
% newer, the built-in function |localfunctions| can be used. In 2013b and 
% 2014a, |localfunctions| is not able to see functions inside of packages, 
% and is somewhat broken for our purposes. In 2013a and older releases,
% |localfunctions| doesn't exist.
%
% This gisves us the following three situations you may be in.

%% I use function-based tests (and I only care about 2016a or older)
% You _technically_ don't need to change anything. Your tests will continue
% to work. However, |inittestsuite| is now deprecated, and you will receive
% warnings when your tests run. This functionality will be removed in a
% future major release.

%% I use function-based tests (and I only care about 2013b or newer)
% The replacement for |inittestsuite| is |buildFunctionHandleTestSuite|,
% and you will pipe the cell array from |localfunctions| into it.

dbtype examples_2016b_compatibility/testUsingFunctions.m 1:2

%% I use function-based tests (and I don't fall into either prior category)
% If you have function-based tests that you want or need to run against
% *both* 2016b or newer *and* 2013a or older, then you have additional work
% to do. You will have to first create the cell array of function handles,
% using some seriously fugly syntax. Then you can call
% |buildFunctionHandleTestSuite| with the cell array you created.

dbtype examples_2016b_compatibility/testUsingFunctionsAndSubFunHandles.m 1:4

%%
% Unfortunately, there is no other way to handle all test suite types 
% across that many releases.

%% 
% <../index.html Back to MATLAB xUnit Test Framework>