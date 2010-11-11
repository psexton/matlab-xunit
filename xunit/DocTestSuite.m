classdef DocTestSuite < TestSuite
    methods
        
        function self = DocTestSuite(name)
            %DocTestSuite constructor
            % suite = DocTestSuite(name);
            % Constructs a suite of DocTests by looking in the m-file named
            % by name.
            
            self.Name = sprintf('DocTestSuite(''%s'')', name);
            
            components = DocTestSuite.getAllComponents(name);
            for C = 1:length(components)
                component = components{C};
                if DocTestSuite.functionHasDocTests(component)
                    self.add(DocTest(component));
                end
            end
            
        end
        
    end
    methods (Static)
        
        function allComponents = getAllComponents(name)
            % Find all bits of a function or class that *might* have
            % doctests.  That is, the top-level doc, and all the methods
            % including the constructor.
            allComponents = {name};
    
            theMethods = methods(name);
            for I = 1:length(theMethods)
                allComponents{end+1} = sprintf('%s.%s', name, theMethods{I});
            end
            
        end
            
        function hasTests = functionHasDocTests(name)
            
            
            docString = help(name);
            
            
            match = regexp(docString, DocTest.example_re, 'names', 'once');
            hasTests = ~ isempty(match);
        end
    end
    
    
end
