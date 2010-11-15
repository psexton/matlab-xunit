classdef DocTest < TestComponent
    %DocTest
    %
    % This TestComponent represents a single help(...) output, which is a
    % logical unit because variables defined earlier in the help text
    % should carry over to later parts.  For instance, this example is
    % internally represented as two DocTestCases in one DocTest:
    %
    % >> x = 17;
    % >> x
    % x = 17
    %
    %
    % This lets x be carried over from one to the next.
    %
    %
    properties
        MethodName
        DocString
        Examples
    end
    
    properties (Constant)
        % loosely based on Python 2.6 doctest.py, line 510
        example_re = '(?m)(?-s)(?:^ *>> )(?<source>.*)\n(?<want>(?:(?:^ *$\n)?(?!\s*>>).*\w.*\n)*)';
    end
    

    methods
        function self = DocTest(testMethod)
            % DocTest Constructor
            
            % the software under test is the help document of the supplied
            % method:
            self.Name = sprintf('DocTest(''%s'')', testMethod);
            self.MethodName = sprintf('help(''%s'')', testMethod);
            self.DocString = help(testMethod);  
            
            
           
            
            % Detect all the examples.
            self.Examples = regexp(self.DocString, DocTest.example_re, 'names', 'warnings');
        end
        
        function num = numTestCases(self)
            % The number of test cases in this doctest
            %
            % >> dt = DocTest('help'); % it has no test cases
            % >> dt.numTestCases()
            % ans = 0
            num = numel(self.Examples);
        end
        
        function print(self, numLeadingBlanks)
            % Print a representation of this doctest, with leading blanks
            fprintf('%sTest of %s\n', blanks(numLeadingBlanks), self.MethodName);
        end
        
        function DOCTEST__all_passed = run(DOCTEST__self, DOCTEST__monitor)
            % Run all the tests in this unit of documentation.
            %
            % All the variables in this function begin with DOCTEST__.
            % That's because the namespace of this function and of the
            % doctest that's being run are intermingled.  This is
            % unavoidable, as far as I can tell. With the DOCTEST__ prefix,
            % it's very hard to unintentionally step on these internal
            % variables when writing a doctest.  It does make it hard to
            % read, though...
            %
            % This is a test that shows whether all the variables that are
            % predefined in a doctest start with the DOCTEST__ prefix:
            % >> all_names = who();
            % >> sum(cell2mat(strfind(all_names, 'DOCTEST__'))) == length(all_names)
            % ans = 1
            %
            

            if nargin < 2
                DOCTEST__monitor = CommandWindowTestRunDisplay();
            end
            
            DOCTEST__all_passed = true;
            DOCTEST__monitor.testComponentStarted(DOCTEST__self);
            
            DOCTEST__examples_to_run = DOCTEST__self.Examples;
          
            
            for DOCTEST__I = 1:numel(DOCTEST__examples_to_run)
                DOCTEST__Case = DocTestCase( ...
                    sprintf('%s_test_%d', DOCTEST__self.MethodName, DOCTEST__I));
                DOCTEST__monitor.testComponentStarted(DOCTEST__Case);
                try
                    DOCTEST__testresult = evalc(DOCTEST__examples_to_run(DOCTEST__I).source);
                
                catch DOCTEST__exception
                    DOCTEST__testresult = DOCTEST__format_exception(DOCTEST__exception);
                end
                
                
                DOCTEST__did_pass = 0;
                try
                    DOCTEST__did_pass = DOCTEST__self.compare_or_exception(DOCTEST__examples_to_run(DOCTEST__I).want, DOCTEST__testresult, DOCTEST__I);
                catch DOCTEST__compare_exception
                    DOCTEST__monitor.testCaseFailure(DOCTEST__Case, DOCTEST__compare_exception)
                end
                
                DOCTEST__all_passed = DOCTEST__all_passed && DOCTEST__did_pass;
                
              
                DOCTEST__monitor.testComponentFinished(DOCTEST__Case, DOCTEST__did_pass);
            end
            
            DOCTEST__monitor.testComponentFinished(DOCTEST__self, DOCTEST__all_passed);
            
        end
        
        function did_pass = compare_or_exception(self, want, got, testnum)
            % Matches two strings together... they should be identical,
            % except that the first one can contain '***', which matches
            % anything in the second string. Also, spacing differences are
            % ignored (one or more vertical or horizontal spaces are
            % collapsed down to one space).
            %
            % But there are also some tricksy things that Matlab does to
            % strings.  Such as add hyperlinks to help.  This doctest tests
            % that condition.
            %
            % >> disp('Hi there!  <a href="matlab:help help">foo</a>')
            % Hi there!  foo
            %
            %
            % They also sometimes backspace over things for no apparent
            % reason.  This doctest recreates that condition.
            %
            % >> sprintf('There is no letter x here: x\x08')
            %
            % ans =
            %
            % There is no letter x here:
            %
            %
            % The comparison is space-insensitive:
            % >> 3
            % 
            % ans =
            % 
            %      3
            % 
            % >> 3
            % ans = 3
            %
            %
            % All of the doctests should pass, and they manipulate this
            % function.
            %

            want = regexprep(want, '\s+', ' ');
            got = regexprep(got, '\s+', ' ');
            
            % This looks bad, like hardcoding for lower-case "a href"
            % and a double quote... but that's what MATLAB looks for too:
            % an <A HREF won't work, only <a href.
            got = regexprep(got, '<a +href=".*?>', '');
            got = regexprep(got, '</a>', '');
            
            % WHY do they need backspaces?  huh.
            got = regexprep(got, '.\x08', '');
            
            want = strtrim(want);
            got = strtrim(got);
            
            if isempty(want) && isempty(got)
                did_pass = 1;
                return
            end
            
            want_escaped = regexptranslate('escape', want);
            want_re = regexprep(want_escaped, '(\\\*){3}', '.*');
            
            
            
            result = regexp(got, want_re, 'once');
            
            did_pass = ~ isempty(result);
            
            if ~ did_pass
                assertEqual(want, got, sprintf('DocTest #%d from %s failed; expected first, got second', ...
                    testnum, self.MethodName));
            end
            
        end
    end
end
