function testSuite = testRunxunitWithDirectoryName
%testRunxunitWithDirectoryName Unit test for mtest('dirname') syntax.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function testDirName
current_dir = pwd;
target_dir = fullfile(fileparts(which(mfilename)), 'cwd_test');
[T, did_pass] = evalc('runxunit(target_dir)');
assertFalse(did_pass);
assertEqual(current_dir, pwd);
