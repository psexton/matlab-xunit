function value = persistValue(newValue)
  persistent perVal
  
  if ~exist('perVal', 'var')
    perVal = [];
  end
  value = perVal;
  
  if exist('newValue', 'var')
    perVal = newValue;
  end
end
