classdef LaneStop < handle
    % LaneStop Selecting waypoints according to the signal color.
    %
    
    properties (Access = private)
        node;
        pub_traffic;
        sub_light;
        sub_light_managed;
        sub_red;
        sub_green;
        sub_config;
        config_manual_detection = true;
        current_red_lane = rosmessage('autoware_msgs/LaneArray');
        current_green_lane = rosmessage('autoware_msgs/LaneArray');
        previous_lane = current_red_lane;
    end

    methods
        function obj = LaneStop()
            % LaneStop Construct a LaneStop object

            % --- Initialize the ROS node ---
            obj.node = robotics.ros.Node('lane_stop_ml');
        end
        
        function [] = Start(obj)
            % --- Set Parameter ---
            ptree = rosparam();	% Create a ParameterTree object.
            if ptree.has('lane_stop/sub_light_queue_size')            
                sub_light_queue_size = ptree.get('lane_stop/sub_light_queue_size');
            else
                sub_light_queue_size = 1;
            end            
            if ptree.has('lane_stop/sub_waypoint_queue_size')
                sub_waypoint_queue_size = ptree.get('lane_stop/sub_waypoint_queue_size');
            else
                sub_waypoint_queue_size = 1;
            end            
            if ptree.has('lane_rule/sub_config_queue_size')
                sub_config_queue_size = ptree.get('lane_rule/sub_config_queue_size');
            else
                sub_config_queue_size =  1;
            end            
            if ptree.has('lane_stop/pub_waypoint_queue_size')
                pub_waypoint_queue_size = ptree.get('lane_stop/pub_waypoint_queue_size'); %#ok<*NASGU>
            else
                pub_waypoint_queue_size = 1;
            end            
            if ptree.has('lane_stop/pub_waypoint_latch')
                pub_waypoint_latch = ptree.get('lane_stop/pub_waypoint_latch');
            else
                pub_waypoint_latch = true;
            end
            
            % --- Creates publisher ---
            obj.pub_traffic = ...
                robotics.ros.Publisher(obj.node, '/traffic_waypoints_array', 'autoware_msgs/LaneArray', ...
                                       'IsLatching', pub_waypoint_latch);            
            % --- Creates subscriber ---
            obj.sub_light = ...
                robotics.ros.Subscriber(obj.node, '/light_color', 'autoware_msgs/traffic_light', ...
                                        @obj.receiveAutoDetection, 'BufferSize', sub_light_queue_size);
            obj.sub_light_managed = ...
                robotics.ros.Subscriber(obj.node, '/light_color_managed', 'autoware_msgs/traffic_light', ...
                                        @obj.receiveManualDetection, 'BufferSize', sub_light_queue_size);
            obj.sub_red = ...
                robotics.ros.Subscriber(obj.node, '/red_waypoints_array', 'autoware_msgs/LaneArray', ...
                                        @obj.cacheRedLane, 'BufferSize', sub_waypoint_queue_size);
            obj.sub_green = ...
                robotics.ros.Subscriber(obj.node, '/green_waypoints_array', 'autoware_msgs/LaneArray', ...
                                        @obj.cacheGreenLane, 'BufferSize', sub_waypoint_queue_size);
            obj.sub_config = ...
                robotics.ros.Subscriber(obj.node, '/config/lane_stop', 'autoware_msgs/ConfigLaneStop', ...
                                        @obj.configParameter, 'BufferSize', sub_config_queue_size);
        end
        
        function delete(obj) %#ok<INUSD>
            disp('Delete LaneStop object.');
        end
    end
    
    methods (Access = private)
        function [] = receiveAutoDetection(obj, sub, msg) %#ok<INUSL>
            % receiveAutoDetection Callback that runs when the subscriber object handle receives a topic message
            if not(obj.config_manual_detection)
                selectCurrentLane(msg);
            end
        end
        
        function [] = receiveManualDetection(obj, sub, msg) %#ok<INUSL>
            % receiveManualDetection Callback that runs when the subscriber object handle receives a topic message
            if obj.config_manual_detection
                selectCurrentLane(msg);
            end
        end
        
        function [] = cacheRedLane(obj, sub, msg) %#ok<INUSL>
            % cacheRedLane Callback that runs when the subscriber object handle receives a topic message
            obj.current_red_lane = msg;
        end
        
        function cacheGreenLane(obj, sub, msg) %#ok<INUSL>
            % cacheGreenLane Callback that runs when the subscriber object handle receives a topic message
            obj.current_green_lane = msg;
        end
        
        function configParameter(obj, sub, msg) %#ok<INUSL>
            % configParameter Callback that runs when the subscriber object handle receives a topic message
            obj.config_manual_detection = msg.manual_detection;
        end

        function [] = selectCurrentLane(obj, msg)
            switch msg.TrafficLight
                case autoware.TrafficLight.RED
                    current = obj.current_red_lane;
                case autoware.TrafficLight.GREEN
                    current = obj.current_green_lane;
                case autoware.TrafficLight.UNKNOWN
                    current = obj.previous_lane;
                otherwise
                    disp('undefined traffic light');
                    return;
            end
            obj.pub_traffic.send(current);
            obj.previous_lane = current;
        end
    end
end
% [EOF]