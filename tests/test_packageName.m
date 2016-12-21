function testSuite = test_packageName
testSuite = buildFunctionHandleTestSuite(localfunctions);

function test_happyCase
suite = TestSuite.fromPackageName('xunit.mocktests');
assertEqual(numel(suite.TestComponents), 5);

theTestComponent = findTestComponent(suite, 'xunit.mocktests.subpkg');
assertEqual(numel(theTestComponent.TestComponents), 1);

theTestComponent = findTestComponent(suite, 'xunit.mocktests.A');
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

components = [suite.TestComponents{:}];
index = find(strcmp(name, {components.Name}), 1);
assertTrue(~ isempty(index), ['Could not find test component for ' name]);

theTestComponent = suite.TestComponents{index};

function test_badPackageName
assertExceptionThrown(@() TestSuite.fromPackageName('bogus'), ...
    'xunit:fromPackageName:invalidName');

