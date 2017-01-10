function testSuite = testRunxunitWithDirectoryName
%testRunxunitWithDirectoryName Unit test for mtest('dirname') syntax.

localFunctionHandles = cellfun(@str2func, ...
  which('-subfun', mfilename('fullpath')), 'UniformOutput', false);
testSuite = buildFunctionHandleTestSuite(localFunctionHandles);

function testDirName
current_dir = pwd;
target_dir = fullfile(fileparts(which(mfilename)), 'cwd_test');
[T, did_pass] = evalc('runxunit(target_dir)');
assertFalse(did_pass);
assertEqual(current_dir, pwd);
