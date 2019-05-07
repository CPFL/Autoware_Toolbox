function [] = createCustomMessages()
%
% Create custom messages from ROS definitions.
%
% --
% Autor(s): Noriyuki OTA, March 25, 2019
% Copyright 2019 NEXTY Electronics Corporation
% 

msg_folder_path = fullfile(autoware.getRootDirectory(), 'custom_msgs');
rosgenmsg(msg_folder_path);

% [EOF]