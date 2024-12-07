function matlabVersion = getMatlabVersion()
%GETMATLABVERSION Returns MATLAB's version, as a double
%   For 2023b and newer, the integer part is the year, and the fractional
%   part specifies the release number:
%   * 2023b = 23.2
%   * 2024a = 24.1
%   For 2023a and older, it's more arbitary, but lookup tables can be found
%   online:
%   * 2012b = 8.0
%   * 2013b = 8.2
%   * 2016a = 9.0
%   * 2023a = 9.14

% There are 4 commands that can be used to compute the MATLAB release
% version: ver, version, matlabRelease, and isMATLABReleaseOlderThan.
% isMATLABReleaseOlderThan is what we what, but it was only added in 202b,
% along with matlabRelease, so those are out. ver is not recommended for
% use in 2023b or newer. So that leaves version. 
% version returns a string like "23.2.0.2599560 (R2023b) Update 8", which
% we can convert to a numerically comparable form by keeping only the part
% before the second period.
matlabVersion = str2double(regexp(version, '^\d+\.\d+', 'match', 'once'));

end

