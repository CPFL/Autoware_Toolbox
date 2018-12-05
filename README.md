# Autoware_matlab_simulink
MATLAB/Simulink sample code suite for Autoware is provided. [Autoware](https://github.com/CPFL/Autoware) provides a rich set of self-driving modules composed of sensing, computing, and actuation capabilities. By using this samples, several applications can be used from MATLAB/Simulink.

## Requirements
- Preinstallation of Autoware ([here](https://github.com/CPFL/Autoware/wiki/Source-Build))
- MATLAB
	- Robotics System Toolbox

## Provided Samples
|module|node|Description|
|:--|:--|:--|
|Detection|ACF Detector|Detecting people using aggregate channel features (ACF).|
|Localization|Vel pose connect|Determining the velocity and pose of the vehicle.|
|Mission Planning|Lane Stop|Selecting waypoints according to the signal color.|
||Lane Rule||
|Motion Plannint|Path Select|Generating final waypoints from temporal waypoints.|
||Pure Pursuit|Generating the actuation commands for the autonomous vehicle.|
||Twist filter|Filtering the received actuation command.|
|filters|Voxel Grid Filter|Downsampling point cloud using a voxel grid filter.
||Random Filter|Downsampling point cloud with random sampling and without replacement.|
||Nonuniform Voxel Grid Filte|Downsampling point cloud using nonuniform voxel grid filter.|
||Fog rectification|Producing defogged image.|

|Node|Support||Topic Info||||Toolbox|
||MATLAB|Simulink|Topic|Message type|Publish|Subscribe||
|:--|:--|:--|:--|:--|:--|:--|:--|

|a!r2!|b!c2!|c!r2c2!|a|e|
|:--|:--|:--|:--|:--|:--|:--|
|^|q!h!|w!h!|e!h!|r!h!|t!h!|p!h!|
|^|q|w|e|r|t|p|

## Node details
|a|b!c2!|c|a|e|r|
|:--|:--|:--|:--|:--|:--|:--|
|^|q!h!|w!h!|e!h!|r!h!|t!h!|p!h!|
|^|q|w|e|r|t|p|


