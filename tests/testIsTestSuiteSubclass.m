classdef testIsTestSuiteSubclass < TestCase
    %testIsTestSuiteSubclass Unit tests for isTestSuiteSubclass
    
    methods
        function self = testIsTestSuiteSubclass(name)
            self = self@TestCase(name);
        end
        
        function testTestSuite(~)
            assertEqual(false, xunit.utils.isTestSuiteSubclass('TestSuite'));
        end
        
        function testSubclass(~)
            assertEqual(true, xunit.utils.isTestSuiteSubclass('xunit.mocktests.C'));
        end
        
        function testNotASubclass(~)
            assertEqual(false, xunit.utils.isTestSuiteSubclass('atan2'));
        end
    end
end
