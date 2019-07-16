# Provided ROS Node Examples

## MATLAB ROS Node Examples
|module|node|Description|
|:--|:--|:--|
|Detection|[ACF Detector](./Detection/acf_detector_ml_en.md)|Detecting people using aggregate channel features (ACF).|
| |[LiDAR Euclidean Track](./Detection/lidar_euclidean_track_ml_en.md)| |
| |[Vision Dummy Track](./Detection/vision_dummy_track_ml_en.md)| |
|Localization|[Vel pose connect](./Localization/vel_pose_connect_ml_en.md)|Determining the velocity and pose of the vehicle.|
|Mission Planning|[Lane Stop](./Planning/lane_stop_ml_en.md)|Selecting waypoints according to the signal color.|
|Motion Planning|[Path Select](./Planning/path_select_ml_en.md)|Generating final waypoints from temporal waypoints.|
|   |[Wf Simulator](./Planning/wf_simulator_ml_en.md)| |
|Filters|[Voxel Grid Filter](./Filters/voxel_grid_filter_ml_en.md)|Downsampling point cloud using a voxel grid filter.|
|	|[Random Filter](./Filters/demo_random_filter_ml_en.md)|Downsampling point cloud with random sampling and without replacement.|
|	|[Nonuniform Voxel Grid Filte](./Filters/nonuniformgrid_filter_ml_en.md)|Downsampling point cloud using nonuniform voxel grid filter.|
|	|[Fog rectification](./Filters/fog_rectification_ml_en.md)|Producing defogged image.|

## Simulink ROS Node Examples 
|module|node|Description|
|:--|:--|:--|
|Detection|[ACF Detector](./Detection/acf_detector_sl_en.md)|Detecting people using aggregate channel features (ACF).|
| |[Vision Dummy Track](./Detection/vision_dummy_track_sl_en.md)| |
|Localization|[Vel pose connect](./Localization/vel_pose_connect_sl_en.md)|Determining the velocity and pose of the vehicle.|
|Mission Planning|[Lane Stop](./Planning/lane_stop_sl_en.md)|Selecting waypoints according to the signal color.|
|Motion Planning|[Path Select](./Planning/path_select_sl_en.md)|Generating final waypoints from temporal waypoints.|
|	|[Pure Pursuit](./Planning/pure_pursuit_sl_en.md)|Generating the actuation commands for the autonomous vehicle.|
|	|[Twist filter](./Planning/twist_filter_sl_en.md)|Filtering the received actuation command.|
