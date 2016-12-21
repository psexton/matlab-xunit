function testSuite = test_a_bit
testSuite = buildFunctionHandleTestSuite( ...
  cellfun(@str2func, which('-subfun', mfilename('fullpath')), ...
  'UniformOutput', false));

function test_now

function test_later
