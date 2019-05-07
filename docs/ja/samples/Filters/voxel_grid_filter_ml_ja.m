%% VoxelGridFilter.m �̗��p��
% 
%% 1. Autoware �̋N��
% 
% Autoware �����s���� ROS �}�X�^�[���N�����܂��B
% 
% <<images/run_autoware.png>>
% 
% Runtime Manager �������オ��܂��B
% 
% <<images/runtime_manager.png>>
% 
%% 2. �V�~�����[�V�����N���b�N�̐ݒ�iRuntime Manager �� Simulation �^�u�j
% 
% Runtime Manager �� Simulation �^�u���J���܂��B
% �uRef�v�{�^�����N���b�N���āA�Đ����� rosbag �t�@�C����ݒ肵�܂��B
% 
% <<images/set_rosbag.png>>
% 
% �uPlay�v�{�^�����N���b�N����rosbag ���Đ���i���}�@�j�A�uPause�v�{�^�����N���b�N���ꎞ��~�����܂��i���}�A�j�B
% ����ɂ��V�~�����[�V�����N���b�N���I���ɂȂ�܂��B
% 
% <<images/simulation_clock_on.png>>
% 
%% 3. LiDAR �ʒu�ݒu�Ǝԗ����f���̃��[�h�iRuntime Manager �� Setup �^�u�j
% 
% Runtime Manager �� Setup �^�u���J���܂��B
% Localizer�� �� Velodyne ��I�����܂��B
% 
% <<images/set_localizer_velodyne.png>>
% 
% Baselink to Localizer ���̃p�����[�^���ȉ��̂悤�ɐݒ肵�A�uTF�v�{�^�����N���b�N���܂��B
% 
% <<images/set_baselink_to_localizer.png>>
% 
% Vehicle Model ���́uVehicle Model�v�{�^�����N���b�N���āA�ԗ����f�������[�h���܂��B  
% �t�@�C���I�𕔂��󗓂ɂ��Ă������ƂŁA�f�t�H���g�̎ԗ����f�������[�h����܂��B
% 
% <<images/load_vehicle_model.png>>
% 
%% 4. �n�}�f�[�^��TF�̃��[�h�iRuntime Manager �� Map �^�u�j
% 
% Runtime Manager �� Map �^�u���J���܂��B
% 
% # �uPoint Cloud�v�{�^���̉E���́uRef�v�{�^�����N���b�N���āA���Ȉʒu����Ɏg�p���� pcd �t�@�C����S�đI�����A
% �uPoint Cloud�v�{�^�����N���b�N���܂��B
% # �uTF�v�{�^���̉E���uRef�v�{�^�����N���b�N���āApcd �f�[�^�ɑΉ����� TF ��񂪐ݒ肳�ꂽ launch �t�@�C����I�����A
% �uTF�v�{�^�����N���b�N���܂��B
% 
% <<images/map_tab.png>>
% 
%% 5. ����m�F�ɕK�v�ȃm�[�h���N���iRuntime Manager �� Computing �^�u�j
% 
%  Runtime Manager �� Computing �^�u���J���܂��B
% nmea2tfpose �� app ���N���b�N���Đݒ��ʂ��J���APlane number ���u7�v�ɐݒ��A�uOK�v�{�^�����N���b�N���܂��B
% 
% <<images/set_plane_number.png>>
% 
% ndt_matching �� app ���N���b�N���Đݒ��ʂ��J���A�uGNSS�v��I����A�uOK�v�{�^�����N���b�N���܂��B
% 
% <<images/ndt_matching_app.png>>
% 
% nmea2tfpose �� ndt_matching �̃`�F�b�N�{�b�N�X�Ƀ`�F�b�N�����܂��B  
% 
% <<images/set_computing_tab.png>>
% 
%% 6. MATLAB ���� Autoware�iROS �}�X�^�[�j�ւ̐ڑ�
% 
% MATLAB �� rosinit �R�}���h���g�p���� ROS �}�X�^�[�ɐڑ����܂��B  
% 
rosinit('http://169.254.66.185:11311');

%% 7. VoxelGridFilter.m �̋N��
% 
% VoxelGridFilter.m �N���X�t�@�C��������t�H���_�� MATLAB �����p�X�ɓo�^��A
% VoxelGridFilter �̃C���X�^���X�𐶐����A�t�B���^���������s���܂��B
% 
voxel_grid_filter_folder = fullfile(autoware.getRootDirectory(), ...
                        'benchmark', 'sensing', 'filters', 'points_downsampler', ...
                        'voxel_grid_filter');
addpath(voxel_grid_filter_folder);
voxel_grid_filter_obj = VoxelGridFilter();

%% 8. rosbag �̍Đ��iRuntime Manager �� Simulation �^�u�j
% 
% �uPause�v�{�^�����N���b�N���āArosbag ���Đ����܂��B
% 
% <<images/replay_rosbag.png>>
% 
%% 9. rviz �̋N��
% 
% Runtime Manager �� RViz �{�^�����N���b�N���� rviz ���N�����܂��B  
% 
% <<images/click_rviz.png>>
% 
% rviz ���N��������A���j���[�́mFile�n-�mOpen Config�n����uAutoware/ros/src/.config/rviz/default.rviz�v��I�����܂��B
% Runtime Manager �Ń��[�h�����f�[�^�� rosbag �̃f�[�^���\������܂��B
% 
% <<images/voxel_grid_filter_ml/show_rviz.png>>
% 
%% 10. �t�B���^�����̊m�F
% 
% rviz �� Points Cluster �� Topic ���u/points_raw�v�ɐݒ肵�A�t�B���^�����O�̓_�Q���m�F���܂��B
% 
% <<images/voxel_grid_filter_ml/points_raw.png>>
% 
% ���ɁAPoints Cluster �� Topic ���u/filtered_points�v�ɐݒ�ύX���A�t�B���^������̓_�Q���m�F���܂��B
% 
% <<images/voxel_grid_filter_ml/filtered_points.png>>
% 
% �_�E���T���v�����O����Ă��邱�Ƃ��m�F�ł��܂��B
% 
% �{����s���̃m�[�h�O���t�摜���m�F����ɂ�
% <images/voxel_grid_filter_ml/rosgraph_voxel_grid_filter_ml.png ����> ���A
% SVG�t�@�C�����m�F����ɂ�
% <images/voxel_grid_filter_ml/rosgraph_voxel_grid_filter_ml.svg ����> ���N���b�N���Ă��������B
% VoxelGridFilter.m �Ő��������m�[�h�� /voxel_grid_filter_ml �ł��B
% 
%% 11. �I������
% 
% ���L�̃R�}���h�����s���ďI�����܂��B  
% 
voxel_grid_filter_obj.delete();
rosshutdown();
rmpath(voxel_grid_filter_folder);
clear voxel_grid_filter_obj voxel_grid_filter_folder;