function [] = autoware_toolbox_setup()
% AUTOWARE_TOOLBOX_SETUP Set up Autoware Toolbox to work with MATLAB.
% 
% --
% Autor(s): Noriyuki OTA, March 25, 2019
% Copyright 2019 NEXTY Electronics Corporation
% 

%% ロケールの取得
% Get locale.
% 
locale = java.util.Locale.getDefault().getLanguage();
ja_locale = strcmp(locale, 'ja');

%% MATLAB Release の確認
% Verify MATLAB Release.
% 
supported_release = {'2018a', '2018b'};
release = version('-release');
switch release
    case supported_release
        % Nothing to do.
    otherwise
        if ja_locale
            msg = 'サポートされていないMATLABリリースです。';
        else
            msg = 'Unsupported MATLAB release.';
        end
        errordlg(msg);
        return;
end

%% 開始メッセージ表示
% Display start message.
% 
mytarget = 'Autoware Toolbox';
if ja_locale
    fprintf(1, '### %sの使用準備を開始します...\n', mytarget);
else
    fprintf(1, '### Start preparing for using %s...\n', mytarget);
end

%% 現在のフォルダーを本ファイルのあるフォルダーに設定
% Set current folder to the folder where this file is stored.
% 
awtb_root = fileparts(mfilename('fullpath'));
old_fld = cd(awtb_root);
c = onCleanup(@() cd(old_fld));

%% MATLABパスの設定
% Add folders to search path.
% 
if ja_locale
    fprintf(1, '### %sフォルダーをMATLAB検索パスに設定しています...\n', mytarget);
else
    fprintf(1, '### Add %s folder to the search path...\n', mytarget);    
end
addpath(pwd);

if ja_locale
    path_doc_folder = fullfile(pwd, 'docs', 'ja');
    fprintf(1, '### docs%sja フォルダー(%s)をMATLABパスに設定しています...\n', filesep(), path_doc_folder);
else
    path_doc_folder = fullfile(pwd, 'docs', 'en');
    fprintf(1, '### Add docs%sen folder(%s) to the search path...\n', filesep(), path_doc_folder);    
end
addpath(path_doc_folder);

path_samples_folder = fullfile(path_doc_folder, 'samples');
if ja_locale
    fprintf(1, '### docs%sja%ssamples フォルダー(%s)をMATLABパスに設定しています...\n', ...
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

%% 検索データベースの構築
% Build searchable documentation database.
% 
if ja_locale
    fprintf(1, '### 検索データベースを構築しています...\n');
else
    fprintf(1, '### Building searchable documentation database...\n');   
end
builddocsearchdb(path_doc_folder);

%% 終了メッセージ表示
% Display end message.
% 
if ja_locale
    fprintf(1, '### %sの使用準備完了!\n', mytarget);
else
    fprintf(1, '### Ready to use %s.\n', mytarget);    
end

%% Autoware Toolbox のインストールドキュメンテーションを MATLAB ブラウザで開く
% Open Autoware Toolbox Installation documentation in MATLAB browser.
% 
if ja_locale
    awtb_doc = fullfile(awtb_root, 'docs', 'ja', 'install_awtb_ja.html');
else
    awtb_doc = fullfile(awtb_root, 'docs', 'en', 'install_awtb_en.html');
end
web(awtb_doc);

% [EOF]