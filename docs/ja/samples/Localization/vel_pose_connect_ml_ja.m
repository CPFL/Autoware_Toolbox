%% VelPoseConnect.m �̗��p��
% 
%% 1. Autoware �̋N��
% 
% Autoware �����s���� ROS �}�X�^�[���N�����܂��B
% 
% <<../images/run_autoware.png>>
%
% Runtime Manager �������オ��܂��B
% 
% <<../images/runtime_manager.png>>
% 
% <html><br></html>
% 
%% 2. Runtime Manager �� Setup �^�u���̐ݒ�
% 
% �ԗ����f�������[�h���܂��B
% 
% <<../images/setup_tab_load_vehicle_model.png>>
% 
% <html><br></html>
% 
%% 3. Runtime Manager �� Map �^�u���̐ݒ�
% 
% Vector Map �� TF ��ǂݍ��݂܂��B
% 
% <<../images/map_tab_load_vectormap_tf.png>>
% 
% <html><br></html>
% 
%% 4. rviz �̋N��
% 
% Runtime Manager �� RViz �{�^�����N���b�N���� rviz ���N�����܂��B
% 
% <<../images/click_rviz.png>>
% 
% rviz ���N��������A���j���[����mFile�n-�mOpen Config�n��I�����܂��B
% 
% <<../images/rviz_file_open_config.png>>
% 
% �t�@�C���I����ʂŁu~/Autoware/ros/src/.config/rviz/default.rviz�v��I�����܂��B
% 
% <<../images/choose_file_to_open.png>>
% 
% Config �ݒ��Arviz ��ʂɂ� Vector Map ���\������܂��B
% 
% <<../images/show_vectormap.png>>
% 
% <html><br></html>
% 
%% 5. Runtime Manager �� Computing �^�u���̐ݒ�
% 
% (1) waypoint_loader �� app ���N���b�N���āA�o�H���ۑ�����Ă��� csv �t�@�C�����w�肵�܂��B
% 
% <<../images/waypoint_loader.png>>
%
% �t�@�C�����w�肵����AComputing �^�u���� waypoint_loader �̃`�F�b�N�{�b�N�X�Ƀ`�F�b�N�����܂��B
% 
% (2) lane_rule�Alane_stop�Alane_select�Aobstacle_avoid�Avelocity_set�A
% pure_pursuit�Atwist_filter�Awf_simulator �̃`�F�b�N�{�b�N�X�Ƀ`�F�b�N�����āA�����̃m�[�h���N�����܂��B
% �ݒ��� Computing �^�u�͉��}�̂悤�ɂȂ�܂��B
% 
% <<images/vel_pose_connect/computing_tab.png>>
% 
% <html><br></html>
% 
%% 6. MATLAB ���� Autoware�iROS �}�X�^�[�j�ւ̐ڑ�
% 
% MATLAB �� rosinit �R�}���h���g�p���� ROS �}�X�^�[�ɐڑ����܂��B
% rosinit �̈����͂����g�̊��ɍ��킹�Đݒ肵�Ă��������B
% 
rosinit();
%%
% 
% <<images/rosinit.png>>
% 
%% 7. MATLAB�ō쐬���� vel_pose_connect ���N��
% 
% VelPoseConnect �N���X�t�@�C��������t�H���_��MATLAB�����p�X�ɓo�^��A
% VelPoseConnect �N���X�̃C���X�^���X�𐶐����Avel_pose_connect �m�[�h���N�����܂��B
% 
vel_pose_connect_folder = fullfile(autoware.getRootDirectory(), ...
                        'benchmark', 'computing', 'perception', 'localization', 'autoware_connector', 'vel_pose_connect');
addpath(vel_pose_connect_folder);
sim_mode = true;
obj_vel_pose_connect = VelPoseConnect(sim_mode);
%%
% 
% <<images/vel_pose_connect/run_vel_pose_connect.png>>
%  
%% 8. rviz �Ŏԗ��̏����ʒu��ݒ�
% 
%  (1) rviz �́u2D Pose Estimate�v���N���b�N���܂��B
%  (2) ���̌�A�ԗ��̏����ʒu����ړ������Ƀ}�E�X�h���b�O���Ė���ݒ肵�܂��B
% 
% <<images/2D_Pose_Estimate.png>>
% 
% <html><br></html>
% 
%% 9. �o�H�Ǐ]�̊J�n
% 
% rviz �ŏ����ʒu��ݒ�サ�΂炭����ƁA�o�H�Ǐ]���n�܂�܂��B
% 
% <<images/result_waypoint_follower.png>>
% 
% �{����s���̃m�[�h�O���t�̃C���[�W�t�@�C�����m�F����ɂ�
% <images/vel_pose_connect/rosgraph.png ����>���N���b�N���Ă��������B
% SVG�t�@�C�����m�F����ɂ�
% <images/vel_pose_connect/rosgraph.svg ����> ���N���b�N���Ă��������B
% VelPoseConnect.m �Ő��������m�[�h�́A�{��ɂ����Ă� " *_/pose_relay_ml_* " �� " _*/vel_relay_ml*_ " �ł��B
% 
%% 10. �I������
% 
% ���L�̃R�}���h�����s���ďI�����܂��B
% 
obj_vel_pose_connect.delete()
rosshutdown();
rmpath(vel_pose_connect_folder);
clear obj_vel_pose_connect vel_pose_connect_folder;