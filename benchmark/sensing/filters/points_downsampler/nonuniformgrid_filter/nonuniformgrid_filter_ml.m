global pub_nonuniformgrid_filter

node_nonuniformgrid_filter = robotics.ros.Node('nonuniformgrid_filter_ml');
sub_nonuniformgrid_filter = robotics.ros.Subscriber(node_nonuniformgrid_filter, '/points_raw', 'sensor_msgs/PointCloud2', @nonuniformgrid_filter_callback);
pub_nonuniformgrid_filter = robotics.ros.Publisher(node_nonuniformgrid_filter, '/filtered_points', 'sensor_msgs/PointCloud2');


function nonuniformgrid_filter_callback(~, msg)
	global pub_nonuniformgrid_filter
	ptCloud = pointCloud(readXYZ(msg), 'intensity', readField(msg, 'intensity'));
	ptCloud.Color = cast(horzcat(ptCloud.Intensity, ptCloud.Intensity, ptCloud.Intensity), 'uint8');

	maxNumPoints = 6.0;
	filtered_ptCloud = pcdownsample(ptCloud, 'gridAverage', maxNumPoints);
	filtered_ptCloud.Intensity = cast(filtered_ptCloud.Color(:, 1), 'single');

	ptMsg = PointCloudToPointCloud2(filtered_ptCloud);
	send(pub_nonuniformgrid_filter, ptMsg);

	function ptMsg = PointCloudToPointCloud2(filtered_ptCloud)
		ptMsg = rosmessage('sensor_msgs/PointCloud2');
		ptMsg.Header = msg.Header;
		% ptMsg.Height = size(filtered_ptCloud.Location,1);
		% ptMsg.Width = size(filtered_ptCloud.Location,2);
		ptMsg.Height = 1;inputinput
		ptMsg.Width = size(filtered_ptCloud.Location,1);
		ptMsg.PointStep = 32;
		ptMsg.RowStep = ptMsg.Width * ptMsg.PointStep;
		for k = 1:4
		    ptMsg.Fields(k) = rosmessage('sensor_msgs/PointField');
		end
		ptMsg.Fields(1).Name = 'x';
		ptMsg.Fields(1).Offset = 0;
		ptMsg.Fields(1).Datatype = 7;
		ptMsg.Fields(1).Count = 1;
		ptMsg.Fields(2).Name = 'y';
		ptMsg.Fields(2).Offset = 4;
		ptMsg.Fields(2).Datatype = 7;
		ptMsg.Fields(2).Count = 1;
		ptMsg.Fields(3).Name = 'z';
		ptMsg.Fields(3).Offset = 8;
		ptMsg.Fields(3).Datatype = 7;
		ptMsg.Fields(3).Count = 1;
		ptMsg.Fields(4).Name = 'intensity';
		ptMsg.Fields(4).Offset = 16;
		ptMsg.Fields(4).Datatype = 7;
		ptMsg.Fields(4).Count = 1;

		locs = reshape(filtered_ptCloud.Location,[],3);
		intensities = reshape(filtered_ptCloud.Intensity,[],1);
		data = [locs zeros(size(locs,1),1,'single') intensities zeros(size(locs,1),3,'single')];
		dataPacked = reshape(permute(data,[2 1]),[],1);
		dataCasted = typecast(dataPacked,'uint8');
		ptMsg.Data = dataCasted;
	end
end