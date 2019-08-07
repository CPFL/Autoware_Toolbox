classdef PathSelect < handle
    % PathSelect Generating final waypoints from temporal waypoints..
    %
    
    properties (Access = private)
        node;        
        pub_final_waypoints;
        sub_temporal_waypoints;
    end
    
    methods
        function obj = PathSelect()
            % PathSelect Construct a PathSelect object
            %

            % --- Initialize the ROS node ---
            obj.node = robotics.ros.Node('paht_select_ml');
            % --- Creates publisher ---
            obj.pub_final_waypoints = ...
                robotics.ros.Publisher(obj.node, '/final_waypoints', 'autoware_msgs/lane');            
            % --- Creates subscriber ---
            obj.sub_temporal_waypoints = ...
                robotics.ros.Subscriber(obj.node, '/temporal_waypoints', 'autoware_msgs/lane', ...
                                        @obj.temporal_waypoints_callback);
        end
        
        function delete(obj) %#ok<INUSD>
            disp('Delete PathSelect object.');
        end
    end
    
    methods (Access = private)        
        function [] = temporal_waypoints_callback(obj, sub, msg) %#ok<INUSL>
            obj.pub_final_waypoints.send(msg)
        end        
    end
end
% [EOF]