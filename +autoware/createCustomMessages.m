function [] = createCustomMessages()
%
% Create custom messages from ROS definitions.
%
% --
% Autor(s): Noriyuki OTA, March 25, 2019
% Copyright 2019 NEXTY Electronics Corporation
% 

mfile_path = fileparts(mfilename('fullpath'));
msg_folder_path = fullfile(mfile_path, '..', 'custom_msgs');
rosgenmsg(msg_folder_path);

% [EOF]