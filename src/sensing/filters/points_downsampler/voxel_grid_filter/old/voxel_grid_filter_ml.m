%% Initialization

obj.videoPlayer = vision.VideoPlayer('Position', [29, 597,643,386]);

%% Define node
node = robotics.ros.Node('voxel_grid_filter_ml');
sub = robotics.ros.Subscriber(node, '/points_raw', 'sensor_msgs/PointCloud2', @voxel_grid_filter_callback);

function voxel_grid_filter_callback(~, msg)
	ptCloud = pointCloud(readXYZ(msg), 'intensity', readField(msg, 'intensity'));

	% gridStep is voxelsize [m]
	gridStep = 2.0;
	filtered_ptCloud = pcdownsample(ptCloud, 'gridAverage', gridStep);

    pcshow(filtered_ptCloud);
end