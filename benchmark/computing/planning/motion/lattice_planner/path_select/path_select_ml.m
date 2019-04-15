global pub_final_waypoints;

node = robotics.ros.Node('paht_select_ml');
pub_final_waypoints = robotics.ros.Publisher(node, '/final_waypoints', 'autoware_msgs/lane');
sub_temporal_waypoints = robotics.ros.Subscriber(node, '/temporal_waypoints', 'autoware_msgs/lane', @temporal_waypoints_callback);

function temporal_waypoints_callback(~, msg)
    global pub_final_waypoints;
    
    send(pub_final_waypoints, msg)
end