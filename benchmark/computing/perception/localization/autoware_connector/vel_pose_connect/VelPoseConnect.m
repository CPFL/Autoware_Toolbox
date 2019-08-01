classdef VelPoseConnect < handle
    % VelPoseConnect Determining the velocity and pose of the vehicle.
    %
    
    properties (Access = private)
        node_pose_relay;
        node_vel_relay;
        node_can_status_translator;
        pub_current_pose;
        pub_current_velocity;
        pub_can_velocity;
        pub_linear_velocity_viz;
        pub_vehicle_status;
        sub_sim_pose;
        sub_sim_velocity;
        sub_can_info;
        sub_vehicle_status
        sim_mode = true;
        v_info = VehicleInfo();
    end
    
    methods
        function obj = VelPoseConnect(sim_mode)
            % VelPoseConnect Construct a VelPoseConnect object
            %
            
            % --- Check argument ---
            if nargin == 1
                obj.sim_mode = sim_mode;
            end
            % --- Initialize the ROS node ---
            obj.node_pose_relay = robotics.ros.Node('pose_relay_ml');
            obj.node_vel_relay = robotics.ros.Node('vel_relay_ml');
            obj.node_can_status_translator = robotics.ros.Node('can_status_translator_ml');
            % --- Creates publisher ---
            if obj.sim_mode
                obj.pub_current_pose = robotics.ros.Publisher(obj.node_pose_relay, ...
                                                              '/current_pose', ...
                                                              'geometry_msgs/PoseStamped');
                obj.pub_current_velocity = robotics.ros.Publisher(obj.node_vel_relay, ...
                                                                  '/current_velocity', ...
                                                                  'geometry_msgs/TwistStamped');
            else
                obj.pub_can_velocity = robotics.ros.Publisher(obj.node_can_status_translator, ...
                                                              '/can_velocity', ...
                                                              'geometry_msgs/TwistStamped');
                obj.pub_linear_velocity_viz = robotics.ros.Publisher(obj.node_can_status_translator, ...
                                                                     '/linear_velocity_viz', ...
                                                                     'std_msgs/Float32');
                obj.pub_vehicle_status = robotics.ros.Publisher(obj.node_can_status_translator, ...
                                                                '/vehicle_status', ...
                                                                'autoware_msgs/VehicleStatus');
            end
            % --- Creates subscriber ---
            if obj.sim_mode
                obj.sub_sim_pose = robotics.ros.Subscriber(obj.node_pose_relay, ...
                                                           '/sim_pose', 'geometry_msgs/PoseStamped', ...
                                                           @obj.simPoseCallback, 'BufferSize', 10);
                obj.sub_sim_velocity = robotics.ros.Subscriber(obj.node_vel_relay, ...
                                                               '/sim_velocity', 'geometry_msgs/TwistStamped', ...
                                                               @obj.simVelocityCallback, 'BufferSize', 10);
            else
                obj.sub_can_info = robotics.ros.Subscriber(obj.node_can_status_translator, ...
                                                           '/can_info', 'autoware_msgs/CanInfo', ...
                                                           @obj.callbackFromCanInfo, 'BufferSize', 100);
                obj.sub_vehicle_status = robotics.ros.Subscriber(node_can_status_translator, ...
                                                                 '/vehicle_status', ...
                                                                 'autoware_msgs/VehicleStatus', ...
                                                                 @obj.callbackFromVehicleStatus, 'BufferSize', 10);
            end
            % --- Set v_info ---
            if obj.sim_mode
                % Nothing to do.
            else
                ptree = rosparam();	% Create a ParameterTree object.
                exist_wheel_base = ptree.has('/vehicle_info/wheel_base');
                exist_minimum_turning_radius = ptree.has('/vehicle_info/minimum_turning_radius');
                exist_maximum_steering_angle = ptree.has('/vehicle_info/maximum_steering_angle');
                if not(exist_wheel_base) || not(exist_minimum_turning_radius) || not(exist_maximum_steering_angle)
                    obj.v_info.is_stored = false;
                    disp('vehicle_info is not set');
                else
                    obj.v_info.wheel_base = ptree.get('/vehicle_info/wheel_base');
                    obj.v_info.minimum_turning_radius = ptree.get('/vehicle_info/minimum_turning_radius');
                    obj.v_info.maximum_steering_angle = ptree.get('/vehicle_info/maximum_steering_angle');
                    obj.v_info.is_stored = true;
                end
            end
        end
        
        function delete(obj) %#ok<INUSD>
            disp('Delete VelPoseConnect object.');
        end
    end
    
    methods (Access = private)
        function [] = simPoseCallback(obj, sub, msg) %#ok<INUSL>
            % simPoseCallback Callback that runs when the subscriber object handle receives a topic message
            obj.pub_current_pose.send(msg);
        end
        
        function [] = simVelocityCallback(obj, sub, msg) %#ok<INUSL>
            % simVelocityCallback Callback that runs when the subscriber object handle receives a topic message
            obj.pub_current_velocity.send(msg);
        end
        
        function [] = callbackFromCanInfo(obj, sub, msg) %#ok<INUSL>
            % callbackFromCanInfo Callback that runs when the subscriber object handle receives a topic message
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
            obj.pub_vehicle_status.send(vs);
        end
        
        function [] = callbackFromVehicleStatus(obj, sub, msg) %#ok<INUSL>
            % callbackFromVehicleStatus Callback that runs when the subscriber object handle receives a topic message
            obj.publishVelocity(msg);
            obj.publishVelocityViz(msg);
        end
        
        function [] = publishVelocity(obj, msg)
            tw = rosmessage('geometry_msgs/TwistStamped');
            tw.Header = msg.Header;
            tw.Twist.Linear.X = kmph2mps(msg.Speed);    % linear velocity
            tw.Twist.Angular.Z = SteeringAnglar2AngularVelocity(tw.Twist.Linear.X, msg.Angle);  % anglar velocity
            obj.pub_can_velocity.send(tw);
        end
        
        function [] = publishVelocityViz(obj, msg)
            fl = rosmessage('std_msgs/Float32');
            fl.Data = msg.Speed;
            obj.pub_linear_velocity_viz.send(fl);
        end
    end
    
end

function linear = kmph2mps(velocity_kmph)
    linear = (velocity_kmph * 1000) / (60 * 60);
end

function anglar = SteeringAnglar2AngularVelocity(cur_vel_mps, cur_angle_deg)
    if v_info.is_stored == true
        anglar = tan(deg2rad(getCurrentTireAngle(cur_angle_deg))) * cur_vel_mps / v_info.wheel_base;
    else
        anglar = 0;
    end
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
% [EOF]