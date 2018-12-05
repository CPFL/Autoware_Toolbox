global detector;
global pub_acf_detector;

node = robotics.ros.Node('acf_detector_ml');
pub_acf_detector =robotics.ros.Publisher(node, '/obj_person/image_obj', 'autoware_msgs/image_obj');
sub = robotics.ros.Subscriber(node, '/image_raw', 'sensor_msgs/Image', @callback_acf_detector);

detector = peopleDetectorACF('inria');

function callback_acf_detector(~, image_source)
	global detector;
    global pub_acf_detector;
    msg = rosmessage('autoware_msgs/image_obj');
    
    msg.Header = image_source.Header;
    msg.Type = 'Person';
    
	I = readImage(image_source);
    [bboxes, scores] = detect(detector, I);
   
    if ~isempty(bboxes)
        num = size(bboxes);
        j = 1;
        for i = 1 : num(1)
            image_rect = robotics.ros.custom.msggen.autoware_msgs.image_rect;
            if scores(i) > 15            
                image_rect.X = bboxes(i, 1);
                image_rect.Y = bboxes(i, 2);
                image_rect.Height = bboxes(i, 4);
                image_rect.Width = bboxes(i, 3);
                image_rect.Score = scores(i);
                msg.Obj(j) = image_rect;
                j = j + 1;
            end
        end
    end
    send(pub_acf_detector, msg);
end