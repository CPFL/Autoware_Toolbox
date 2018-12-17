classdef TwistGate < handle
    
    properties (Access=private)
        node
        vehicle_cmd_pub
        auto_cmd_sub
        twist_gate_msg
    end
    
    methods (Access=public)
        function obj = TwistGate()
            obj.node = robotics.ros.Node('twist_gate_ml');
            obj.vehicle_cmd_pub = robotics.ros.Publisher(obj.node, '/vehicle_cmd', 'autoware_msgs/VehicleCmd');
            obj.auto_cmd_sub = containers.Map('KeyType', 'char', 'ValueType', 'any');
            obj.auto_cmd_sub('twist_cmd') = robotics.ros.Subscriber(obj.node, '/twist_cmd', 'geometry_msgs/TwistStamped', @obj.autoCmdTwistCmdCallback);
            obj.twist_gate_msg = rosmessage('autoware_msgs/VehicleCmd');
            obj.twist_gate_msg.Header.Seq = 0;
        end
        
        function delete(obj) %#ok<INUSD>
        end
    end
    
    methods (Access=private)
        function autoCmdTwistCmdCallback(obj, sub, msg) %#ok<INUSL>
            obj.twist_gate_msg.Header.FrameId = msg.Header.FrameId;
            obj.twist_gate_msg.Header.Stamp = msg.Header.Stamp;
            obj.twist_gate_msg.Header.Seq = obj.twist_gate_msg.Header.Seq + 1;
            obj.twist_gate_msg.TwistCmd.Twist = msg.Twist;
            send(obj.vehicle_cmd_pub, obj.twist_gate_msg);
        end
    end
end
