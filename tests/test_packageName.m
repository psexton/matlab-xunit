function testSuite = test_packageName
localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function test_happyCase
suite = TestSuite.fromPackageName('xunit.mocktests');
assertEqual(numel(suite.TestComponents), 6);

theTestComponent = findTestComponent(suite, 'xunit.mocktests.subpkg');
assertEqual(numel(theTestComponent.TestComponents), 1);

theTestComponent = findTestComponent(suite, 'xunit.mocktests.A');
assertEqual(numel(theTestComponent.TestComponents), 2);

theTestComponent = findTestComponent(suite, 'xunit.mocktests.C');
assertEqual(numel(theTestComponent.TestComponents), 2);

theTestComponent = findTestComponent(suite, 'xunit.mocktests.FooTest');
assertEqual(numel(theTestComponent.TestComponents), 1);

theTestComponent = findTestComponent(suite, 'xunit.mocktests.test_this');
assertEqual(numel(theTestComponent.TestComponents), 1);

theTestComponent = findTestComponent(suite, 'test_that');
assertEqual(numel(theTestComponent.TestComponents), 2);

% Make sure we'd get an exception if a test wasn't there
assertExceptionThrown(...
    @() findTestComponent(suite, 'test_does_not_exist'), ...
    'assertTrue:falseCondition');

function theTestComponent = findTestComponent(suite, name)
% Find the TestComponent given a name of a function under test.
%
% This is needed because meta.package.fromName() doesn't sort its list of
% functions, so the ordering isn't always stable.

componentNames = cellfun(@(x) x.Name, suite.TestComponents, 'UniformOutput', false);
index = find(strcmp(name, componentNames), 1);
assertTrue(~ isempty(index), ['Could not find test component for ' name]);

theTestComponent = suite.TestComponents{index};

function test_badPackageName
assertExceptionThrown(@() TestSuite.fromPackageName('bogus'), ...
    'xunit:fromPackageName:invalidName');

