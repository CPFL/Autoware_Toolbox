# Autoware Toolbox で提供されている Autoware の ROS ノードの例

## MATLAB で作成した Autoware の ROSノード
|module|node|Description|
|:--|:--|:--|
|Detection|[ACF Detector](./Detection/acf_detector_ml_ja.html)|Detecting people using aggregate channel features (ACF).|
| |[LiDAR Euclidean Track](./Detection/lidar_euclidean_track_ml_ja.html)| |
| |[Vision Dummy Track](./Detection/vision_dummy_track_ml_ja.html)| |
|Localization|[Vel pose connect](./Localization/vel_pose_connect_ml_ja.html)|Determining the velocity and pose of the vehicle.|
|Mission Planning|[Lane Stop](./Planning/lane_stop_ml_ja.html)|Selecting waypoints according to the signal color.|
|Motion Planning|[Path Select](./Planning/path_select_ml_ja.html)|Generating final waypoints from temporal waypoints.|
|   |[Wf Simulator](./Planning/wf_simulator_ml_ja.md)| |
|Filters|[Voxel Grid Filter](./Filters/voxel_grid_filter_ml_ja.html)|Downsampling point cloud using a voxel grid filter.|
|	|[Random Filter](./Filters/demo_random_filter_ml_ja.html)|Downsampling point cloud with random sampling and without replacement.|
|	|[Nonuniform Voxel Grid Filte](./Filters/nonuniformgrid_filter_ml_ja.html)|Downsampling point cloud using nonuniform voxel grid filter.|
|	|[Fog rectification](./Filters/fog_rectification_ml_ja.html)|Producing defogged image.|

## Simulink で作成した Autoware の ROS ノード 
|module|node|Description|
|:--|:--|:--|
|Detection|[ACF Detector](./Detection/acf_detector_sl_ja.html)|Detecting people using aggregate channel features (ACF).|
| |[Vision Dummy Track](./Detection/vision_dummy_track_sl_ja.html)| |
|Localization|[Vel pose connect](./Localization/vel_pose_connect_sl_ja.html)|Determining the velocity and pose of the vehicle.|
|Mission Planning|[Lane Stop](./Planning/lane_stop_sl_ja.html)|Selecting waypoints according to the signal color.|
|Motion Planning|[Path Select](./Planning/path_select_sl_ja.html)|Generating final waypoints from temporal waypoints.|
|	|[Pure Pursuit](./Planning/pure_pursuit_sl_ja.html)|Generating the actuation commands for the autonomous vehicle.|
|	|[Twist filter](./Planning/twist_filter_sl_ja.html)|Filtering the received actuation command.|
