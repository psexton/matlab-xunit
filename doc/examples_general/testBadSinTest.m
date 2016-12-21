function testSuite = testBadSinTest
testSuite = buildFunctionHandleTestSuite(localfunctions);

function testSinPi
% Example of a failing test case.  The test writer should have used
% assertAlmostEqual here.
assertEqual(sin(pi), 0);
