function testSuite = testCos
testSuite = buildFunctionHandleTestSuite(localfunctions);

function testTooManyInputs
assertExceptionThrown(@() cos(1, 2), 'MATLAB:maxrhs');