global config_manual_detection;
global current_red_lane;
global current_green_lane;
global previous_lane;


config_manual_detection = true;
current_red_lane = rosmessage('autoware_msgs/LaneArray');
current_green_lane = rosmessage('autoware_msgs/LaneArray');
previous_lane = current_red_lane;

node1 = robotics.ros.Node('lane_stop_matlab');
ptree = robotics.ros.ParameterTree(node1);

if(has(ptree,'lane_stop/sub_light_queue_size'))
    sub_light_queue_size = get(ptree,'lane_stop/sub_light_queue_size');
else
    sub_light_queue_size = 1;
end

if(has(ptree,'lane_stop/sub_waypoint_queue_size'))
    sub_waypoint_size = get(ptree,'lane_stop/sub_waypoint_queue_size');
else
    sub_waypoint_size = 1;
end
if(has(ptree,'lane_rule/sub_config_queue_size'))
    sub_config_queue_size = get(ptree,'lane_rule/sub_config_queue_size');
else
    sub_config_queue_size =  1;
end
if(has(ptree,'lane_stop/pub_waypoint_queue_size'))
    pub_waypoint_queue_size = get(ptree,'lane_stop/pub_waypoint_queue_size');
else
    pub_waypoint_queue_size = 1;
end
if(has(ptree,'lane_stop/pub_waypoint_latch'))
    pub_waypoint_latch = get(ptree,'lane_stop/pub_waypoint_latch');
else
    pub_waypoint_latch = true;
end

global traffic_pub;
traffic_pub = robotics.ros.Publisher(node1,'/traffic_waypoints_array','autoware_msgs/LaneArray');
global current;
current = rosmessage(traffic_pub);

light_sub = robotics.ros.Subscriber(node1,'/light_color','autoware_msgs/traffic_light',@receive_auto_detection);
light_managed_sub = robotics.ros.Subscriber(node1,'/light_color_managed','autoware_msgs/traffic_light',@receive_manual_detection);
red_sub = robotics.ros.Subscriber(node1,'/red_waypoints_array','autoware_msgs/LaneArray',@cache_red_lane);
green_sub = robotics.ros.Subscriber(node1,'/green_waypoints_array','autoware_msgs/LaneArray',@cache_green_lane);
config_sub = robotics.ros.Subscriber(node1,'/config/lane_stop','autoware_msgs/ConfigLaneStop',@config_parameter);

function receive_auto_detection(~, msg)
    global config_manual_detection;
	if not(config_manual_detection)
        select_current_lane(msg);
    end
end
function receive_manual_detection(~, msg)
    global config_manual_detection;
	if config_manual_detection
		select_current_lane(msg);
    end
end
function cache_red_lane(~, msg)
global current_red_lane;
	current_red_lane = msg;
end
function cache_green_lane(~, msg)
global current_green_lane;
	current_green_lane = msg;
end
function config_parameter(~, msg)
global config_manual_detection;
	config_manual_detection = msg.manual_detection;
end
function ret = select_current_lane(msg)
    global previous_lane;
    global current_red_lane;
    global current_green_lane;
    global current;
    switch msg.TrafficLight
    	case 0
        	current = current_red_lane;
    	case 1
        	current = current_green_lane;
		case 2
			current = previous_lane;
        otherwise
			return
	end

    global traffic_pub
    send(traffic_pub,current)
    previous_lane = current;
    ret = 0;
end