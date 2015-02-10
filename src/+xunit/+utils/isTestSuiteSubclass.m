function tf = isTestSuiteSubclass(name)

class_meta = meta.class.fromName(name);
if isempty(class_meta)
    % Not the name of a class
    tf = false;
else
    tf = class_meta < ?TestSuite;
end
