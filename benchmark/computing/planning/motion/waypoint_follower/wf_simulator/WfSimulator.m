classdef WfSimulator < handle
    
    properties (Access=private)
        node
        odometry_pub
        velocity_pub
        cmd_sub
        initialpose_sub
        main_loop_timer
        cleanup
        
        current_velocity
        linear_acceleration = 0.0;
        steering_angle = 0.0;
        previous_linear_velocity = 0.0;
        initial_pose
        initial_set = false;
        pose_set = false;
        current_time
        last_time
        pose
        th = 0.0;
    end
    
    properties (Access=private, Constant)
        initialize_source = 'Rviz';
        loop_rate = 50; % 50Hz
        accel_rate = 1.0;
    end
    
    methods (Access=public)
        function obj = WfSimulator()
            obj.node = robotics.ros.Node('wf_simulator_ml');
            obj.odometry_pub = robotics.ros.Publisher(obj.node, 'sim_pose', 'geometry_msgs/PoseStamped');
            obj.velocity_pub = robotics.ros.Publisher(obj.node, 'sim_velocity', 'geometry_msgs/TwistStamped');
            obj.cmd_sub = robotics.ros.Subscriber(obj.node, 'twist_cmd', 'geometry_msgs/TwistStamped', @obj.cmdCallback);
            if strcmp(obj.initialize_source, 'Rviz') == 1
                obj.initialpose_sub = robotics.ros.Subscriber(obj.node, 'initialpose', 'geometry_msgs/PoseWithCovarianceStamped', @obj.initialposeCallback);
            else
                assert(false);
            end
            period = 1.0 / obj.loop_rate;
            obj.main_loop_timer = timer('TimerFcn', @obj.mainLoopTimerCallback,'Period',period,'ExecutionMode','fixedSpacing');
            
            obj.current_velocity = rosmessage('geometry_msgs/Twist');
            obj.initial_pose = rosmessage('geometry_msgs/Pose');
            obj.current_time = rostime("now");
            obj.last_time = rostime("now");
            obj.pose = rosmessage('geometry_msgs/Pose');
        end
        
        function delete(obj)
            stop(obj.main_loop_timer)
            delete(obj.main_loop_timer)
        end
        
        function run(obj)
            start(obj.main_loop_timer);
        end
    end
    
    methods (Access=private)
        
        function cmdCallback(obj, sub, msg) %#ok<INUSL>
            if obj.current_velocity.Linear.X < msg.Twist.Linear.X
                obj.current_velocity.Linear.X = obj.previous_linear_velocity + obj.accel_rate / obj.loop_rate;
                
                if obj.current_velocity.Linear.X > msg.Twist.Linear.X
                    obj.current_velocity.Linear.X = msg.Twist.Linear.X;
                end
            else
                obj.current_velocity.Linear.X = obj.previous_linear_velocity - obj.accel_rate / obj.loop_rate;
                
                if obj.current_velocity.Linear.X < msg.Twist.Linear.X
                    obj.current_velocity.Linear.X = msg.Twist.Linear.X;
                end
            end
            obj.previous_linear_velocity = obj.current_velocity.Linear.X;
            
            obj.current_velocity.Angular.Z = msg.Twist.Angular.Z;
        end
        
        function initialposeCallback(obj, sub, msg) %#ok<INUSL>
            trtree = robotics.ros.TransformationTree(obj.node);
            tf = getTransform(trtree, 'map', 'world', "Timeout", 5);
            obj.initial_pose.Position.X = msg.Pose.Pose.Position.X + tf.Transform.Translation.X;
            obj.initial_pose.Position.Y = msg.Pose.Pose.Position.Y + tf.Transform.Translation.Y;
            obj.initial_pose.Position.Z = msg.Pose.Pose.Position.Z + tf.Transform.Translation.Z;
            obj.initial_pose.Orientation = msg.Pose.Pose.Orientation;
            
            obj.initial_set = true;
            obj.pose_set = false;
        end
        
        function mainLoopTimerCallback(obj, timer, ~) %#ok<INUSD>
            if obj.initial_set == false
                return
            end
            obj.publishOdometry()
        end
        
        function publishOdometry(obj)
            if obj.pose_set == false
                obj.pose.Position = obj.initial_pose.Position;
                obj.pose.Orientation = obj.initial_pose.Orientation;
                quat = [obj.pose.Orientation.W obj.pose.Orientation.X obj.pose.Orientation.Y obj.pose.Orientation.Z];
                euler = quat2eul(quat);
                obj.th = euler(1);
                obj.pose_set = true;
            end
            
            vx = obj.current_velocity.Linear.X;
            vth = obj.current_velocity.Angular.Z;
            obj.current_time = rostime("now");
            
            dt = seconds(obj.current_time - obj.last_time);
            delta_x = (vx * cos(obj.th)) * dt;
            delta_y = (vx * sin(obj.th)) * dt;
            delta_th = vth * dt;
            obj.pose.Position.X = obj.pose.Position.X + delta_x;
            obj.pose.Position.Y = obj.pose.Position.Y + delta_y;
            obj.th = obj.th + delta_th;
            euler = [obj.th 0 0];
            quat = eul2quat(euler);
            obj.pose.Orientation.W = quat(1);
            obj.pose.Orientation.X = quat(2);
            obj.pose.Orientation.Y = quat(3);
            obj.pose.Orientation.Z = quat(4);
            tform = rosmessage('geometry_msgs/TransformStamped');
            tform.Header.Stamp = obj.current_time;
            tform.ChildFrameId = 'sim_base_link';
            tform.Header.FrameId = 'map';
            tform.Transform.Translation.X = obj.pose.Position.X;
            tform.Transform.Translation.Y = obj.pose.Position.Y;
            tform.Transform.Translation.Z = obj.pose.Position.Z;
            tform.Transform.Rotation = obj.pose.Orientation;
            trtree = robotics.ros.TransformationTree(obj.node);
            sendTransform(trtree, tform);
            
            ps = rosmessage('geometry_msgs/PoseStamped');
            ps.Header.Stamp = obj.current_time;
            ps.Header.FrameId = 'map';
            ps.Pose = obj.pose;
            
            ts = rosmessage('geometry_msgs/TwistStamped');
            ts.Header.Stamp = obj.current_time;
            ts.Header.FrameId = 'map';
            ts.Twist.Linear.X = vx;
            ts.Twist.Angular.Z = vth;
            
            send(obj.odometry_pub, ps);
            send(obj.velocity_pub, ts);
            
            obj.last_time = obj.current_time;
        end
        
    end
end
