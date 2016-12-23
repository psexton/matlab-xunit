function testSuite = testUsingFunctionsAndSubFunHandles
localFunctionHandles = cellfun(@str2func, ...
        which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function testFliplrMatrix
in = magic(3);
assertEqual(fliplr(in), in(:, [3 2 1]));

function testFliplrVector
assertEqual(fliplr([1 4 10]), [10 4 1]);
