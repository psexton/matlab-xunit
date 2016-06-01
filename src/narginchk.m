function narginchk(minargs, maxargs)

  if (nargin ~= 2)
    error('%s: Usage: narginchk(minargs, maxargs)',upper(mfilename));
  elseif (~isnumeric (minargs) || ~isscalar (minargs))
    error ('minargs must be a numeric scalar');
  elseif (~isnumeric (maxargs) || ~isscalar (maxargs))
    error ('maxargs must be a numeric scalar');
  elseif (minargs > maxargs)
    error ('minargs cannot be larger than maxargs')
  end


  args = evalin ('caller', 'nargin;');


  if (args < minargs)
    error ('MATLAB:narginchk:notEnoughInputs', 'not enough input arguments');
  elseif (args > maxargs)
    error ('MATLAB:narginchk:tooManyInputs', 'too many input arguments');
  end

end