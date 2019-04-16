function [] = addCustomMessageFolderToSearchPath()
%
% Add the custom message folder to the MATLAB search path.
%
% --
% Autor(s): Noriyuki OTA, March 25, 2019
% Copyright 2019 NEXTY Electronics Corporation
% 

mfile_path = fileparts(mfilename('fullpath'));
custom_msgs_folder = fullfile(mfile_path(1:end-length('+autoware')), 'custom_msgs');
msggen_folder = fullfile(custom_msgs_folder, 'matlab_gen', 'msggen');
addpath(msggen_folder);
savepath();

locale = java.util.Locale.getDefault().getLanguage();
if strcmp(locale, 'ja')
    fprintf(1, '### %s ÇMATLABåüçıÉpÉXÇ…í«â¡ÇµÇ‹ÇµÇΩÅB\n', msggen_folder);
else
    fprintf(1, '### Completed add %s to the MATLAB search path.\n', msggen_folder);
end

% [EOF]