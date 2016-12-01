function testSuite = test_thatFails
testSuite = buildFunctionHandleTestSuite(localfunctions);

function test_case
assertTrue(false);
