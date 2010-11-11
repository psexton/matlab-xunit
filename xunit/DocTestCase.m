classdef DocTestCase < TestCase
  
    methods
        function self = DocTestCase(testMethod)
            %TestCase Constructor
            %   TestCase(methodName) constructs a TestCase object using the
            %   specified testMethod (a string).
            
            self@TestCase(testMethod);
            
        end
        
        function did_pass = run(self, monitor)
            error('Cannot run doctest case directly, use DocTest');
        end
    end
end