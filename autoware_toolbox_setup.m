function [] = autoware_toolbox_setup()
% AUTOWARE_TOOLBOX_SETUP Set up Autoware Toolbox to work with MATLAB.
% 
% --
% Autor(s): Noriyuki OTA, March 25, 2019
% Copyright 2019 NEXTY Electronics Corporation
% 

%% ���P�[���̎擾
% Get locale.
% 
locale = java.util.Locale.getDefault().getLanguage();
ja_locale = strcmp(locale, 'ja');

%% MATLAB Release �̊m�F
% Verify MATLAB Release.
% 
supported_release = {'2018a', '2018b'};
release = version('-release');
switch release
    case supported_release
        % Nothing to do.
    otherwise
        if ja_locale
            msg = '�T�|�[�g����Ă��Ȃ�MATLAB�����[�X�ł��B';
        else
            msg = 'Unsupported MATLAB release.';
        end
        errordlg(msg);
        return;
end

%% �J�n���b�Z�[�W�\��
% Display start message.
% 
mytarget = 'Autoware Toolbox';
if ja_locale
    fprintf(1, '### %s�̎g�p�������J�n���܂�...\n', mytarget);
else
    fprintf(1, '### Start preparing for using %s...\n', mytarget);
end

%% ���݂̃t�H���_�[��{�t�@�C���̂���t�H���_�[�ɐݒ�
% Set current folder to the folder where this file is stored.
% 
awtb_root = fileparts(mfilename('fullpath'));
old_fld = cd(awtb_root);
c = onCleanup(@() cd(old_fld));

%% MATLAB�p�X�̐ݒ�
% Add folders to search path.
% 
if ja_locale
    fprintf(1, '### %s�t�H���_�[��MATLAB�����p�X�ɐݒ肵�Ă��܂�...\n', mytarget);
else
    fprintf(1, '### Add %s folder to the search path...\n', mytarget);    
end
addpath(pwd);

if ja_locale
    path_doc_folder = fullfile(pwd, 'docs', 'ja');
    fprintf(1, '### docs%sja �t�H���_�[(%s)��MATLAB�p�X�ɐݒ肵�Ă��܂�...\n', filesep(), path_doc_folder);
else
    path_doc_folder = fullfile(pwd, 'docs', 'en');
    fprintf(1, '### Add docs%sen folder(%s) to the search path...\n', filesep(), path_doc_folder);    
end
addpath(path_doc_folder);

path_samples_folder = fullfile(path_doc_folder, 'samples');
if ja_locale
    fprintf(1, '### docs%sja%ssamples �t�H���_�[(%s)��MATLAB�p�X�ɐݒ肵�Ă��܂�...\n', ...
                filesep(), filesep(), path_samples_folder);
else
    fprintf(1, '### Add docs%sen%samples folder(%s) to the search path...\n', ...
                filesep(), filesep(), path_samples_folder);    
end
addpath(path_samples_folder);
status = savepath();
if status == 1
    warning('Unable to save current search path.');
end

%% �����f�[�^�x�[�X�̍\�z
% Build searchable documentation database.
% 
if ja_locale
    fprintf(1, '### �����f�[�^�x�[�X���\�z���Ă��܂�...\n');
else
    fprintf(1, '### Building searchable documentation database...\n');   
end
builddocsearchdb(path_doc_folder);

%% �I�����b�Z�[�W�\��
% Display end message.
% 
if ja_locale
    fprintf(1, '### %s�̎g�p��������!\n', mytarget);
else
    fprintf(1, '### Ready to use %s.\n', mytarget);    
end

%% Autoware Toolbox �̃C���X�g�[���h�L�������e�[�V������ MATLAB �u���E�U�ŊJ��
% Open Autoware Toolbox Installation documentation in MATLAB browser.
% 
if ja_locale
    awtb_doc = fullfile(awtb_root, 'docs', 'ja', 'install_awtb_ja.html');
else
    awtb_doc = fullfile(awtb_root, 'docs', 'en', 'install_awtb_en.html');
end
web(awtb_doc);

% [EOF]