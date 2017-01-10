function runTest()
  curPath = pwd;
  cleanUpObj = onCleanup(@() cd(curPath));
  myPath = fileparts(mfilename('fullpath'));
  cd(myPath);
  
  persistValue('testSuiteHasRun');
end
