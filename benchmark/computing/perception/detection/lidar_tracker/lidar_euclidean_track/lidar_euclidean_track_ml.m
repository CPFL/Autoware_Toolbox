global pub_detected_objects
global pub_cloud_cluster_tracked_bounding_box
global pub_cloud_cluster_tracked_text
global v_pre_cloud_cluster
global threshold_dist

v_pre_cloud_cluster = rosmessage('autoware_msgs/CloudCluster');

node = robotics.ros.Node('lidar_euclidean_track_ml');
% ptree = rosparam;
% threshold_dist = get(ptree, "threshold_dist");
threshold_dist = 2.0;
sub_cloud_clusters_class = robotics.ros.Subscriber(node, '/cloud_clusters_class', 'autoware_msgs/CloudClusterArray', @cloud_clusters_class_callback);
pub_detected_objects = robotics.ros.Publisher(node, '/detected_objects', 'autoware_msgs/DetectedObjectArray');
pub_cloud_cluster_tracked_bounding_box = robotics.ros.Publisher(node, '/cloud_cluster_tracked_bounding_box', 'autoware_msgs/DetectedObjectArray');
pub_cloud_cluster_tracked_text = robotics.ros.Publisher(node, '/cloud_cluster_tracked_text', 'visualization_msgs/MarkerArray');

function cloud_clusters_class_callback(~, cloud_cluster_array)
    global pub_detected_objects
    global pub_cloud_cluster_tracked_bounding_box
    global pub_cloud_cluster_tracked_text
    global v_pre_cloud_cluster
    global threshold_dist
    
    base_msg = cloud_cluster_array;
    id = 1;
    cluster_size = numel(base_msg.Clusters);
    v_pre_cloud_cluster_size = numel(v_pre_cloud_cluster);
    
    for i = 1:cluster_size
        cluster_centroid = rosmessage('geometry_msgs/Point');
        min_distance = realmax;
        stamped_id = false;
        cluster_centroid = pos_stamped2pos(base_msg.Clusters(i).CentroidPoint);
        
        for j = 1 : v_pre_cloud_cluster_size
            %pre_cluster_centroid = rosmessage('geometry_msgs/Point');
            pre_cluster_centroid = pos_stamped2pos(v_pre_cloud_cluster(i).CentroidPoint);
            distance = euclid_distance(cluster_centroid, pre_cluster_centroid);
            if and(distance < min_distance, distance < threshold_dist)
                min_distance = distance;
                base_msg.Clusters(i).Id = v_pre_cloud_cluster(i).Id;
                stamped_id = true;
            end
        end
        if ~stamped_id
            base_msg.Clusters(i).Id = id;
            id = id + 1;
            if id > 100
                id = 1;
            end
        end
    end
    
    v_pre_cloud_cluster = rosmessage('autoware_msgs/CloudCluster');
    cluster_size = size(base_msg.Clusters);
    for i = 1:cluster_size
        v_pre_cloud_cluster(i) = base_msg.Clusters(i);
    end
    
    detected_objects_msgs = rosmessage('autoware_msgs/DetectedObjectArray');
    detected_objects_msgs.Header = base_msg.Header;
    for i = 1:cluster_size(1)
        detected_object = robotics.ros.custom.msggen.autoware_msgs.DetectedObject;
        detected_object.Header = base_msg.Clusters(i).Header;
        detected_object.Id = basepub_cloud_cluster_tracked_bounding_box_msg.Clusters(i).Id;
        detected_object.Label= base_msg.Clusters(i).Label;
        detected_object.Dimensions = base_msg.Clusters(i).BoundingBox.Dimensions;
        detected_object.Pose = base_msg.Clusters(i).BoundingBox.Pose;
        detected_objects_msgs.Objects(i) = detected_object;
    end
    
    send(pub_detected_objects, detected_objects_msgs);
    
    pub_bb_msg = rosmessage('jsk_recognition_msgs/BoundingBoxArray');
    pub_bb_msg.Header = base_msg.Header;
    for i = 1:cluster_size
        pub_bb_msg.Boxes(i) = base_msg.Clusters(i).BoundingBox;
        pub_bb_msg.Boxes(i).Value = base_msg.Clusters(i).Id;
    end
    
    send(pub_cloud_cluster_tracked_bounding_box, pub_bb_msg);
    
    pub_textlabel_msg = rosmessage('visualization_msgs/MarkerArray');
    color_white = rosmessage('std_msgs/ColorRGBA');
    color_white.R = 1.0;
    color_white.G = 1.0;
    color_white.B = 1.0;
    color_white.A = 1.0;
    for i = 1:cluster_size
        marker_textlabel = rosmessage('visualization_msgs/Marker');
        marker_textlabel.Header.FrameId = 'velodyne';
        marker_textlabel.Ns = 'cluster';
        marker_textlabel.Id = i;
        marker_textlabel.Type = 9; % visualization_msgs/Marker/TEXT_VIEW_FACING, uint8 TEXT_VIEW_FACING=9
        marker_textlabel.Scale.Z = 1.0;
        marker_textlabel.Text = base_msg.Clusters(i).Label + '@' + num2str(base_msg.Clusters(i).Id);
        marker_textlabel.Pose.Position = base_msg.Clusters(i).BoundingBox.Pose.Position;
        marker_textlabel.Pose.Orientation.X = 0.0;
        marker_textlabel.Pose.Orientation.Y = 0.0;
        marker_textlabel.Pose.Orientation.Z = 0.0;
        marker_textlabel.Pose.Orientation.W = 0.0;
        marker_textlabel.Pose.Position.Z = marker_textlabel.Pose.Position.Z + 1.5;
        marker_textlabel.Lifetime = rosduration(0.2);
        pub_textlabel_msg.Markers(i) = marker_textlabel;
    end
    send(pub_cloud_cluster_tracked_text, pub_textlabel_msg);
end

function out_pos = pos_stamped2pos(in_pos)
    out_pos = in_pos.Point;
end

function distance = euclid_distance(pos1, pos2)
    distance = power(pos1.X - pos2.X, 2) + power(pos1.Y - pos2.Y, 2) + power(pos1.Z - pos2.Z, 2);
end

