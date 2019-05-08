function [] = editJavaClassPath()
% 
% Edit javaclasspath.txt, add the jar file locations as new lines, and save the file.
%
% --
% Autor(s): Noriyuki OTA, March 25, 2019
% Copyright 2019 NEXTY Electronics Corporation
% 

mfile_path = fileparts(mfilename('fullpath'));
custom_msgs_folder = fullfile(mfile_path(1:end-length('+autoware')), 'custom_msgs', 'matlab_gen');
jar_folder = fullfile(custom_msgs_folder, 'jar');
jar_file_locations{1} = fullfile(jar_folder, 'autoware_msgs-1.8.0.jar');
jar_file_locations{2} = fullfile(jar_folder, 'dbw_mkz_msgs-1.8.0.jar');
jar_file_locations{3} = fullfile(jar_folder, 'jsk_recognition_msgs-1.2.5.jar');
jar_file_locations{4} = fullfile(jar_folder, 'vector_map_msgs-1.8.0.jar');
jar_file_locations{5} = fullfile(jar_folder, 'visualization_msgs-1.12.7.jar');

javaclasspath_txt = fullfile(prefdir(), 'javaclasspath.txt');
type = exist(javaclasspath_txt, 'file');
if type ~= 2
    fmt = sprintf('%%s\n');
    new_file = [{'<before>'}, jar_file_locations];
else
    fmt = sprintf('\n%%s');
    A = importdata(javaclasspath_txt);
    new_file = setdiff(jar_file_locations, A);
end
fid = fopen(javaclasspath_txt, 'a+');
c = onCleanup(@() fclose(fid));
fprintf(fid, fmt, new_file{:});
edit(javaclasspath_txt);

% [EOF]