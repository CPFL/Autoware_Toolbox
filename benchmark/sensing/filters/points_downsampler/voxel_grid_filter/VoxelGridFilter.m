classdef VoxelGridFilter < handle
    % VoxelGridFilter Downsampling point cloud using a voxel grid filter.
    
    properties (Access = public)
        grid_step = 2.0     % grid_step is voxelsize [m]
    end
    
    properties (Access = private)
        node
        sub_voxel_grid_filter
        pub_voxel_grid_filter
    end
    
    methods
        function obj = VoxelGridFilter(grid_step)
            % VoxelGridFilter Construct a VoxelGridFilter object
            if nargin == 1
                obj.grid_step = grid_step;
            end
            obj.node = robotics.ros.Node('voxel_grid_filter_ml');
            obj.sub_voxel_grid_filter = robotics.ros.Subscriber(obj.node, '/points_raw', 'sensor_msgs/PointCloud2', @obj.voxelGridFilterCallback);
            obj.pub_voxel_grid_filter = robotics.ros.Publisher(obj.node, '/filtered_points', 'sensor_msgs/PointCloud2');
        end
        
        function delete(obj) %#ok<INUSD>
            disp('Delete VoxelGridFilter object.');
        end
    end
    
    methods (Access = private)
        function [] = voxelGridFilterCallback(obj, sub, msg) %#ok<INUSL>
            % voxelGridFilterCallback Callback that runs when the subscriber object handle receives a topic message
            pt_cloud = pointCloud(msg.readXYZ(), 'intensity', msg.readField('intensity'));
            pt_cloud.Color = cast(horzcat(pt_cloud.Intensity, pt_cloud.Intensity, pt_cloud.Intensity), 'uint8');
            filtered_pt_cloud = pcdownsample(pt_cloud, 'gridAverage', obj.grid_step);
            filtered_pt_cloud.Intensity = cast(filtered_pt_cloud.Color(:, 1), 'single');
            pt_msg = PointCloudToPointCloud2(filtered_pt_cloud, msg.Header);
            send(obj.pub_voxel_grid_filter, pt_msg);
        end
    end
end

function pt_msg = PointCloudToPointCloud2(pt_cloud, msg_header)
    pt_msg = rosmessage('sensor_msgs/PointCloud2');
    pt_msg.Header = msg_header;
    pt_msg.Height = 1;
    pt_msg.Width = size(pt_cloud.Location, 1);
    pt_msg.PointStep = 32;
    pt_msg.RowStep = pt_msg.Width * pt_msg.PointStep;
    for k = 1:4
        pt_msg.Fields(k) = rosmessage('sensor_msgs/PointField');
    end
    pt_msg.Fields(1).Name = 'x';
    pt_msg.Fields(1).Offset = 0;
    pt_msg.Fields(1).Datatype = 7;
    pt_msg.Fields(1).Count = 1;
    pt_msg.Fields(2).Name = 'y';
    pt_msg.Fields(2).Offset = 4;
    pt_msg.Fields(2).Datatype = 7;
    pt_msg.Fields(2).Count = 1;
    pt_msg.Fields(3).Name = 'z';
    pt_msg.Fields(3).Offset = 8;
    pt_msg.Fields(3).Datatype = 7;
    pt_msg.Fields(3).Count = 1;
    pt_msg.Fields(4).Name = 'intensity';
    pt_msg.Fields(4).Offset = 16;
    pt_msg.Fields(4).Datatype = 7;
    pt_msg.Fields(4).Count = 1;
    locs = reshape(pt_cloud.Location, [], 3);
    intensities = reshape(pt_cloud.Intensity, [], 1);
    data = [locs zeros(size(locs, 1), 1, 'single'), intensities, zeros(size(locs, 1), 3, 'single')];
    data_packed = reshape(permute(data, [2 1]), [], 1);
    data_casted = typecast(data_packed, 'uint8');
    pt_msg.Data = data_casted;
end
% [EOF]