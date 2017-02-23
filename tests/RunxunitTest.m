classdef RunxunitTest < TestCaseInDir
    %RUNXUNITTEST Unit tests for runxunit command-line test runner.
    
    methods
        function self = RunxunitTest(name)
            self = self@TestCaseInDir(name, ...
                fullfile(fileparts(which(mfilename)), 'cwd_test'));
        end
        
        function test_noInputArgs(self)
            [T, did_pass] = evalc('runxunit');
            % The cwd_test directory contains some test cases that fail,
            % so output of runxunit should be false.
            assertEqual(did_pass, false);
        end
        
        function test_Verbose(self)
            [T, did_pass] = evalc('runxunit(''-verbose'')');
            assertEqual(did_pass, false);
        end
        
        function test_oneInputArg(self)
            [T, did_pass] = evalc('runxunit(''testFoobar'')');
            % cwd_test/testFoobar.m is supposed to pass.
            assertEqual(did_pass, true);
        end
        
        function test_verboseThenTestName(self)
            [T, did_pass] = evalc('runxunit(''-verbose'', ''.'')');
            assertEqual(did_pass, false);
        end
        
        function test_testNameThenVerbose(self)
            [T, did_pass] = evalc('runxunit(''.'', ''-verbose'')');
            assertEqual(did_pass, false);
        end
        
        function test_oneInputArgWithFilter_passing(self)
            [T, did_pass] = evalc('runxunit(''TestCaseSubclass:testA'')');
            assertEqual(did_pass, true);
        end
        
        function test_oneInputArgWithFilter_failing(self)
            [T, did_pass] = evalc('runxunit(''TestCaseSubclass:testB'')');
            assertEqual(did_pass, false);
        end
        
        function test_oneDirname(self)
            [T, did_pass] = evalc('runxunit(''../dir1'')');
            assertEqual(did_pass, true);
            
            [T, did_pass] = evalc('runxunit(''../dir2'')');
            assertEqual(did_pass, false);
        end
        
        function test_twoDirnames(self)
            [T, did_pass] = evalc('runxunit(''../dir1'', ''../dir2'')');
            assertEqual(did_pass, false);
        end
        
        function test_packageName(self)
            [T, did_pass] = evalc('runxunit(''xunit.mocktests'')');
            assertEqual(did_pass, true);
        end
        
        function test_noTestCasesFound(self)
            assertExceptionThrown(@() runxunit('no_such_test'), ...
                'xunit:runxunit:noTestCasesFound');
        end
        
        function test_optionStringsIgnored(self)
            % Option string at beginning.
            [T, did_pass] = evalc('runxunit(''-bogus'', ''../dir1'')');
            assertEqual(did_pass, true);
            
            % Option string at end.
            [T, did_pass] = evalc('runxunit(''../dir2'', ''-bogus'')');
            assertEqual(did_pass, false);
        end
        
        function test_logfile(self)
            name = tempname;
            command = sprintf('runxunit(''../dir1'', ''-logfile'', ''%s'')', name);
            [T, did_pass] = evalc(command);
            assertEqual(did_pass, true);
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
            assertEqual(did_pass, true);
            
            [T, did_pass] = evalc('runxunit({''TestCaseSubclass:testA'', ''TestCaseSubclass:testB''})');
            assertEqual(did_pass, false);
        end
    end
end
