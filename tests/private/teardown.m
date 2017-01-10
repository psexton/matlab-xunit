function common = teardown()
  common = struct('tearDownHasRun', {true});
  error('xunit:teardown:called', 'This error should not be seen');
end
