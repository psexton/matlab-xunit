function test_suite = test_DocTest
% Here are some doctests!
%
% 
% >> 4 + 7
% 
% ans =
% 
%     11
%     
% >> dicomuid
% 
% ans =
% 
% 1.3.6.1.4.1.***


initTestSuite;

end

function test_thisDoctest
dt = DocTest('test_DocTest');
assertEqual(dt.numTestCases(), 2);
logger = TestRunLogger();
assertTrue(dt.run(logger));
%NumFailures Number of test failures during execution
assertEqual(logger.NumFailures, 0);

%NumErrors Number of test errors during execution
assertEqual(logger.NumErrors, 0);

%NumTestCases Total number of test cases executed
assertEqual(logger.NumTestCases, 2);

end