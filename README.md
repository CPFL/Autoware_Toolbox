# Autoware Toolbox
Autoware Toolbox is a MATLAB/Simulink sample code suite for [Autoware](https://github.com/CPFL/Autoware). Autoware provides a rich set of self-driving modules composed of sensing, computing, and actuation capabilities. By using this samples, several applications can be used from MATLAB/Simulink.

## Requirements
- Preinstallation of Autoware ([here](https://github.com/CPFL/Autoware/wiki/Source-Build))
- MATLAB/Simulink
	- Robotics System Toolbox
	- Computer Vision System Toolbox (optional)
	- Image Processing Toolbox (optional)

##  Release Compatibility
### Autoware Messages
Autoware 1.8.0
### MATLAB/Simulink
Created with R2018b

## Provided Samples
|module|node|Description|MATLAB Code<br>Support|Simulink Model<br>Support|Toolbox|
|:--|:--|:--|:--:|:--:|:--|
|[Detection](./benchmark/computing/perception/detection)|[ACF Detector](./benchmark/computing/perception/detection/vision_detector/acf_detector)|Detecting people using aggregate channel features (ACF).|X|X|Computer Vision System Toolbox<br>Image Processing Toolbox|
| |[LiDAR Euclidean Track](./benchmark/computing/perception/detection/lidar_tracker/lidar_euclidean_track)| |X| | |
| |[Vision Dummy Track](./benchmark/computing/perception/detection/vision_tracker/vision_dummy_track)| |X|X| |
|[Localization](./benchmark/computing/perception/localization)|[Vel pose connect](./benchmark/computing/perception/localization/autoware_connector/vel_pose_connect)|Determining the velocity and pose of the vehicle.|X|X| |
|[Mission Planning](./benchmark/computing/planning/mission)|[Lane Stop](./benchmark/computing/planning/mission/lane_stop)|Selecting waypoints according to the signal color.|X|X| |
|	|[Lane Rule]()|Generating waypoints corresponding to signal color.| | | |
|[Motion Planning](./benchmark/computing/planning/motion)|[Path Select](./benchmark/computing/planning/motion/lattice_planner/path_select)|Generating final waypoints from temporal waypoints.|X|X| |
|	|[Pure Pursuit](./benchmark/computing/planning/motion/waypoint_follower/wf_simulator)|Generating the actuation commands for the autonomous vehicle.| |X| |
|	|[Twist filter](./benchmark/computing/planning/motion/waypoint_follower/twist_filter)|Filtering the received actuation command.| |X| |
|   |[Wf Simulator](./benchmark/computing/planning/motion/waypoint_follower/wf_simulator)| |X| | |
|[Filters](./benchmark/sensing/filters)|[Voxel Grid Filter](./benchmark/sensing/filters/points_downsampler/voxel_grid_filter)|Downsampling point cloud using a voxel grid filter.|X| |Computer Vision System Toolbox|
|	|[Random Filter](./benchmark/sensing/filters/points_downsampler/random_filter)|Downsampling point cloud with random sampling and without replacement.|X| |Computer Vision System Toolbox|
|	|[Nonuniform Voxel Grid Filte](./benchmark/sensing/filters/points_downsampler/nonuniformgrid_filter)|Downsampling point cloud using nonuniform voxel grid filter.|X| |Computer Vision System Toolbox|
|	|[Fog rectification](./benchmark/sensing/filters/image_processor/fog_rectification)|Producing defogged image.|X| | |

## Preparation for use with MATLAB
- [English](docs/en/install_awtb_en.md)
- [Japanese](docs/ja/install_awtb_ja.md)

## Documentation
- [English](docs/en/helptoc_en.md)
- [Japanese](docs/ja/helptoc_ja.md)

## Research Papers for Citation

