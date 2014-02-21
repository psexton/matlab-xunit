%TestSuiteTest Unit tests for runxunit command-line test runner.

classdef RunxunitTest < TestCaseInDir

   methods
       
       function self = RunxunitTest(name)
           self = self@TestCaseInDir(name, ...
               fullfile(fileparts(which(mfilename)), 'cwd_test'));
       end
      
      function test_noInputArgs(self)
          [T, did_pass] = evalc('runxunit');
          % The cwd_test directory contains some test cases that fail,
          % so output of runxunit should be false.
          assertFalse(did_pass);
      end
      
      function test_Verbose(self)
          [T, did_pass] = evalc('runxunit(''-verbose'')');
          assertFalse(did_pass);
      end
      
      function test_oneInputArg(self)
          [T, did_pass] = evalc('runxunit(''testFoobar'')');
          % cwd_test/testFoobar.m is supposed to pass.
          assertTrue(did_pass);
      end
      
      function test_verboseThenTestName(self)
          [T, did_pass] = evalc('runxunit(''-verbose'', ''.'')');
          assertFalse(did_pass);
      end
      
      function test_testNameThenVerbose(self)
          [T, did_pass] = evalc('runxunit(''.'', ''-verbose'')');
          assertFalse(did_pass);
      end
      
      function test_oneInputArgWithFilter_passing(self)
          [T, did_pass] = evalc('runxunit(''TestCaseSubclass:testA'')');
          assertTrue(did_pass);
      end
      
      function test_oneInputArgWithFilter_failing(self)
          [T, did_pass] = evalc('runxunit(''TestCaseSubclass:testB'')');
          assertFalse(did_pass);
      end
      
      function test_oneDirname(self)
          [T, did_pass] = evalc('runxunit(''../dir1'')');
          assertTrue(did_pass);
          
          [T, did_pass] = evalc('runxunit(''../dir2'')');
          assertFalse(did_pass);
      end
      
      function test_twoDirnames(self)
          [T, did_pass] = evalc('runxunit(''../dir1'', ''../dir2'')');
          assertFalse(did_pass);
      end
      
      function test_packageName(self)
          [T, did_pass] = evalc('runxunit(''xunit.mocktests'')');
          assertTrue(did_pass);
      end
      
      function test_noTestCasesFound(self)
          assertExceptionThrown(@() runxunit('no_such_test'), ...
              'xunit:runxunit:noTestCasesFound');
      end
      
      function test_optionStringsIgnored(self)
          % Option string at beginning.
          [T, did_pass] = evalc('runxunit(''-bogus'', ''../dir1'')');
          assertTrue(did_pass);
          
          % Option string at end.
          [T, did_pass] = evalc('runxunit(''../dir2'', ''-bogus'')');
          assertFalse(did_pass);
      end
      
      function test_logfile(self)
          name = tempname;
          command = sprintf('runxunit(''../dir1'', ''-logfile'', ''%s'')', name);
          [T, did_pass] = evalc(command);
          assertTrue(did_pass);
          assertTrue(exist(name, 'file') ~= 0);
          delete(name);
      end
      
      function test_logfileWithNoFile(self)
          assertExceptionThrown(@() runxunit('../dir1', '-logfile'), ...
              'xunit:runxunit:MissingLogfile');
      end
      
      function test_logfileWithNoWritePermission(self)
          if ispc
              assertExceptionThrown(@() runxunit('../dir1', '-logfile', ...
                  'C:\dir__does__not__exist\foobar.txt'), ...
                  'xunit:runxunit:FileOpenFailed');
          else
              assertExceptionThrown(@() runxunit('../dir1', '-logfile', ...
                  '/dir__does__not__exist/foobar.txt'), ...
                  'xunit:runxunit:FileOpenFailed');
          end
      end
      
      function test_namesInCellArray(self)
          [T, did_pass] = evalc('runxunit({''TestCaseSubclass:testA''})');
          assertTrue(did_pass);
          
          [T, did_pass] = evalc('runxunit({''TestCaseSubclass:testA'', ''TestCaseSubclass:testB''})');
          assertFalse(did_pass);
      end
      
   end

end