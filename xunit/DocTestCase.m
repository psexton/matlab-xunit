classdef DocTestCase < TestCase
    %DocTestCase - a single executable line in a doctest
    %
    % This class is essentially a stub, because a single executable line
    % can't be run without context supplied from earlier lines.  So all of
    % the logic lies in the DocTest class.
    %
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