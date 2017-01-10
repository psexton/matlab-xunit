classdef MetaTestRunLogger < TestRunMonitor
    %METATESTRUNLOGGER Combine several test run loggers into one
    %   Implement the 4 methods of a matlab-xunit test logger on each of
    %   a cell array of instantiated input loggers.
    
    properties
        loggers = {};
    end
    
    methods
        function self = MetaTestRunLogger(loggers)
            self.loggers = loggers;
        end
        
        function testComponentStarted(self, component)
            for ii=1:length(self.loggers)
                logger = self.loggers{ii}{1};
                logger.testComponentStarted(component);
            end
        end
        
        function testComponentFinished(self, component, did_pass)
            for ii=1:length(self.loggers)
                logger = self.loggers{ii}{1};
                logger.testComponentFinished(component, did_pass);
            end
        end
        
        function testCaseFailure(self, test_case, failure_exception)
            for ii=1:length(self.loggers)
                logger = self.loggers{ii}{1};
                logger.testCaseFailure(test_case, failure_exception);
            end
        end
        
        function testCaseError(self, test_case, error_exception)
            for ii=1:length(self.loggers)
                logger = self.loggers{ii}{1};
                logger.testCaseError(test_case, error_exception);
            end
        end     
    end
    
end

