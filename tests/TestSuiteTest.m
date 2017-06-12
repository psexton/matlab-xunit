%TestSuiteTest Unit tests for TestSuite class

classdef TestSuiteTest < TestCaseInDir

   methods
      function self = TestSuiteTest(name)
         self = self@TestCaseInDir(name, ...
             fullfile(fileparts(which(mfilename)), 'helper_classes'));
      end
      
      function testClassNameIn(self)
         % Syntax check: TestSuite('classname')
         suite = TestSuite('TwoPassingTests');
         assertTrue(numel(suite.TestComponents) == 2, ...
            'TestSuite finds two test methods given class name');
      end
      
      function testCurrentDirectory(self)
         % See that the no-input syntax executes without error.
         % Not sure how to test this more effectively.
         suite = TestSuite();
      end
      
      function testNoTestMethods(self)
         % TestCase class containing no test methods
         suite = TestSuite('NoTestMethods');
         assertTrue(numel(suite.TestComponents) == 0, ...
            'No test cases when class contains no test methods');
      end
      
      function test_fromTestCaseClassName(self)
          suite = TestSuite.fromTestCaseClassName('TwoPassingTests');
          assertTrue(numel(suite.TestComponents) == 2);
          assertTrue(ismember(suite.TestComponents{1}.Name, ...
              {'testMethod1', 'testMethod2'}));
          assertTrue(ismember(suite.TestComponents{2}.Name, ...
              {'testMethod1', 'testMethod2'}));     
      end
      
      function test_fromTestCaseClassName_badclass(self)
          assertExceptionThrown(@() TestSuite.fromTestCaseClassName('atan2'), ...
              'xunit:fromTestCaseClassName');
      end
      
      function test_fromName_TestCaseSubclass(self)
          suite = TestSuite.fromName('TwoPassingTests');
          assertTrue(numel(suite.TestComponents) == 2);
          assertEqual(suite.Name, 'TwoPassingTests');
      end
      
      function test_fromName_notTestCaseSubclass(self)
          suite = TestSuite.fromName('TestRunMonitor');
          assertTrue(isempty(suite.TestComponents));
          assertEqual(suite.Name, 'TestRunMonitor');
      end
      
      function test_fromName_simpleTest(self)
          suite = TestSuite.fromName('testSimple');
          assertEqual(numel(suite.TestComponents), 1);
          assertEqual(suite.Name, 'testSimple');
          assertEqual(suite.Location, which('testSimple'));
      end
      
      function test_fromName_subfunctions(self)
          suite = TestSuite.fromName('testFunctionHandlesA');
          assertEqual(numel(suite.TestComponents), 2);
          assertEqual(suite.Name, 'testFunctionHandlesA');
          assertEqual(suite.Location, which('testFunctionHandlesA'));
      end
      
      function test_fromName_bogus_name(self)
          suite = TestSuite.fromName('atan2');
          assertTrue(isempty(suite.TestComponents));
          assertEqual(suite.Name, 'atan2');
      end
      
      function test_fromName_with_filter_string(self)
          suite = TestSuite.fromName('testFunctionHandlesA:testA');
          assertEqual(numel(suite.TestComponents), 1);
          assertEqual(suite.TestComponents{1}.Name, 'testA');
          assertEqual(suite.Name, 'testFunctionHandlesA');
      end
      
      function test_fromName_with_nonmatching_filter_string(self)
          suite = TestSuite.fromName('testFunctionHandlesA:foobar');
          assertTrue(isempty(suite.TestComponents));
      end
      
      function test_fromName_with_dirname(self)
         xunit_test_dir = which('TestSuiteTest');
         xunit_test_dir = fileparts(xunit_test_dir);
         cwd_test_dir = fullfile(xunit_test_dir, 'cwd_test');
         suite = TestSuite.fromName(cwd_test_dir);
         
         assertEqual(suite.Name, 'cwd_test');
         assertEqual(suite.Location, cwd_test_dir);
         assertEqual(numel(suite.TestComponents), 3);
      end

      function test_fromName_with_relative_dirname_on_path(self)
         % Passing a partial directory name that is on the MATLAB path will
         % cause a crash if not handled properly, see #14. The
         % 'add_to_path' directory is temporarily added to the path while
         % this test executes from 'helper_classes'.
         test_dir = fullfile(fileparts(mfilename('fullpath')), 'add_to_path');
         addpath(test_dir);
         path_cleanup = onCleanup(@() rmpath(test_dir));
         
         suite = TestSuite.fromName('add_to_path');

         assertEqual(suite.Name, 'add_to_path');
         assertEqual(suite.Location, '');
         assertEqual(numel(suite.TestComponents), 0);
      end
      
      function test_fromName_with_relative_dirname_shadowing_package(self)
          oldPwd = pwd();
          pwdCleaner = onCleanup(@() cd(oldPwd));
          cd(fullfile(fileparts(mfilename('fullpath')), 'shadow_test'))
          
          suite = TestSuite.fromName('shadow');
          
          assertEqual(suite.Name, 'shadow');
          assertEqual(suite.Location, 'shadow');
          assertEqual(numel(suite.TestComponents), 0);
      end

      function test_fromPwd(self)
          % Verify that the fromPwd method returns a nonempty TestSuite object
          % from the helper_classes directory, with the correct number of
          % test components.
          suite = TestSuite.fromPwd();
          assertTrue(isa(suite, 'TestSuite'));
          assertTrue(numel(suite.TestComponents) == 16);
      end
      
   end

end