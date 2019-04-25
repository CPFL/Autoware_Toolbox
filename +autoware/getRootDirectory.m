function awtb_root = getRootDirectory()
% GETROOTDIRECTORY Get the root directory of Autoware Toolbox.
%
% --
% Autor(s): Noriyuki OTA, April 25, 2019
% Copyright 2019 NEXTY Electronics Corporation
% 

mfile_path = fileparts(mfilename('fullpath'));
awtb_root = mfile_path(1:end-length('\+autoware'));

% [EOF]