classdef AcfDetector < handle
    %AcfDetector Detecting people using aggregate channel features (ACF).
    
    properties (Access = private)
        node
        sub_acf_detector
        pub_acf_detector
        detector
    end
    
    methods
        function obj = AcfDetector()
            %AcfDetector Construct a AcfDetector object
            %
            obj.node = robotics.ros.Node('acf_detector_ml');
            obj.sub_acf_detector = robotics.ros.Subscriber(obj.node, '/image_raw', 'sensor_msgs/Image', @obj.callbackAcfDetector);
            obj.pub_acf_detector = robotics.ros.Publisher(obj.node, '/detection/vision_objects', 'autoware_msgs/DetectedObjectArray');
            obj.detector = peopleDetectorACF('inria');
        end
        
        function delete(obj) %#ok<INUSD>
            disp('Delete AcfDetector object.');
        end
    end
    
    methods (Access = private)
        function [] = callbackAcfDetector(obj, sub, image_source) %#ok<INUSL>
            % callbackAcfDetector Callback that runs when the subscriber object handle receives a topic message
            msg = rosmessage('autoware_msgs/DetectedObjectArray');
            msg.Header = image_source.Header;
            I = image_source.readImage();
            [bboxes, scores] = obj.detector.detect(I);
            if ~isempty(bboxes)
                num = size(bboxes);
                j = 1;
                for i = 1 : num(1)
                    detected_object = robotics.ros.custom.msggen.autoware_msgs.DetectedObject();
                    if scores(i) > 15
                        detected_object.Label = 'Person';
                        detected_object.X = bboxes(i, 1);
                        detected_object.Y = bboxes(i, 2);
                        detected_object.Height = bboxes(i, 4);
                        detected_object.Width = bboxes(i, 3);
                        detected_object.Score = scores(i);
                        msg.Objects(j) = detected_object;
                        j = j + 1;
                    end
                end
            end
            obj.pub_acf_detector.send(msg);
        end
    end
end

