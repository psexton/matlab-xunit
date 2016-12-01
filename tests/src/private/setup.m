function common = setup()
  common = struct('setupHasRun', {true});
  error('xunit:setup:called', 'This error should not be seen');
end
