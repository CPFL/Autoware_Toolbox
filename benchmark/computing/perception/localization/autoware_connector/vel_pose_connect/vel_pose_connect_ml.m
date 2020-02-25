global pub_current_pose
global pub_current_velocity
global pub_can_velocity
global pub_linear_velocity_viz
global pub_vehicle_status
global v_info

node_pose_relay = robotics.ros.Node('pose_relay_ml');
node_vel_relay = robotics.ros.Node('vel_relay_ml');
node_can_status_translator = robotics.ros.Node('can_status_translator_ml');
pub_current_pose = robotics.ros.Publisher(node_pose_relay, '/current_pose', 'geometry_msgs/PoseStamped');
pub_current_velocity = robotics.ros.Publisher(node_vel_relay, '/current_velocity', 'geometry_msgs/TwistStamped');

% simulation mode is On : 1
% simulation mode is Off: 0
simulation_mode = 1;

if simulation_mode == 0
    rosinit;
    ptree = rosparam;
    if or(~has(ptree,'/vehicle_info/wheel_base'), or(~has(ptree,'/vehicle_info/minimum_turning_radius'), ~has(ptree,'/vehicle_info/maximum_steering_angle')))
        disp('vehicle_info is not set');
        v_info.is_stored = false;
        v_info.wheel_base = 0.0;
        v_info.minimum_turning_radius = 0.0;
        v_info.maximum_steering_angle = 0.0;
    else
        v_info.is_stored = true;
        v_info.wheel_base = get(ptree, '/vehicle_info/wheel_base');
        v_info.minimum_turning_radius = get(ptree,'/vehicle_info/minimum_turning_radius');
        v_info.maximum_steering_angle = get(ptree,'/vehicle_info/maximum_steering_angle');
    end
    
    pub_can_velocity = robotics.ros.Publisher(node_can_status_translator, '/can_velocity', 'geometry_msgs/TwistStamped');
    pub_linear_velocity_viz = robotics.ros.Publisher(node_can_status_translator, '/linear_velocity_viz', 'std_msgs/Float32');
    pub_vehicle_status = robotics.ros.Publisher(node_can_status_translator, '/vehicle_status', 'autoware_msgs/VehicleStatus');
    
    robotics.ros.Subscriber(node_pose_relay, '/ndt_pose', 'geometry_msgs/PoseStamped', @ndt_pose_callback);
    robotics.ros.Subscriber(node_vel_relay, '/estimate_twist', 'geometry_msgs/TwistStamped', @estimate_twist_callback);
    robotics.ros.Subscriber(node_can_status_translator, '/can_info', 'autoware_can_msgs/CANInfo', @can_info_callback);
    robotics.ros.Subscriber(node_can_status_translator, '/vehicle_status', 'autoware_msgs/VehicleStatus', @vehicle_status_callback); 
else
    robotics.ros.Subscriber(node_pose_relay, '/sim_pose', 'geometry_msgs/PoseStamped', @sim_pose_callback,'BufferSize',10);
    robotics.ros.Subscriber(node_vel_relay, '/sim_velocity', 'geometry_msgs/TwistStamped', @sim_velocity_callback,'BufferSize',10);
end

function ndt_pose_callback(~, msg)
    global pub_current_pose
    send(pub_current_pose, msg);
end

function estimate_twist_callback(~, msg)
    global pub_current_velocity
    send(pub_current_velocity, msg);
end

function can_info_callback(~, msg)
    global pub_vehicle_status
    vs = rosmessage('autoware_msgs/VehicleStatus');
    
    vs.Header = msg.Header;
    vs.Tm = msg.Tm;
    vs.Drivemode = msg.Devmode;
    vs.Steeringmode = msg.Strmode;
    vs.Gearshift = msg.Driveshift;
    vs.Speed = msg.Speed;
    vs.Drivepedal = msg.Drivepedal;
    vs.Brakepedal = msg.Brakepedal;
    vs.Angle = msg.Angle;
    vs.Lamp = 0;
    vs.Light = msg.Light;
    
    send(pub_vehicle_status, vs);
end

function vehicle_status_callback(~, msg)
    global pub_can_velocity
    global pub_linear_velocity_viz
    global v_info
    tw = rosmessage('geometry_msgs/TwistStamped');
    fl = rosmessage('std_msgs/Float32');
    
    tw.Header = msg.Header;
    % linear velocity
    tw.Twist.Linear.X = kmph2mps(msg.Speed);
    % anglar velocity
    tw.Twist.Angular.Z = SteeringAnglar2AngularVelocity(tw.Twist.Linear.X, msg.Angle);
    send(pub_can_velocity, tw);
    
    fl.Data = msg.Speed;
    send(pub_linear_velocity_viz, fl);
    
    function linear = kmph2mps(velocity_kmph)
        linear = (velocity_kmph * 1000) / (60 * 60);
    end
    function anglar = SteeringAnglar2AngularVelocity(cur_vel_mps, cur_angle_deg)
        if v_info.is_stored == true
            anglar = tan(deg2rad(getCurrentTireAngle(cur_angle_deg))) * cur_vel_mps / v_info.wheel_base;
        else
            anglar = 0;
        end
        
        function TireAngle = getCurrentTireAngle(angle_deg)
            TireAngle = angle_deg * rad2deg(asin(v_info.wheel_base / v_info.minimum_turning_radius)) / v_info.maximum_steering_angle;
        end
        function rad = deg2rad(deg)
            rad = deg * pi / 180;
        end
        function deg = rad2deg(rad)
            deg = rad * 180 / pi;
        end
        
    end
end

function sim_pose_callback(~, msg)
    global pub_current_pose
    send(pub_current_pose, msg);
end

function sim_velocity_callback(~, msg)
    global pub_current_velocity
    send(pub_current_velocity, msg);
end