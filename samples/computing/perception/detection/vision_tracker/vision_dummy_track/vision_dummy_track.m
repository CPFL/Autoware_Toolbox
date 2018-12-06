global pub_image_obj_tracked

% car: flag == 1, person = flag == 0
flag = 1;
if flag ==1
    node_name = 'obj_car/dummy_track_ml';
    pub_topic = '/obj_car/image_obj_tracked';
    sub_topic =  '/obj_car/image_obj_ranged';
else
    node_name = 'obj_car/dummy_track_ml';
    pub_topic = '/obj_person/image_obj_tracked';
    sub_topic =  '/obj_person/image_obj_ranged';
end

node = robotics.ros.Node(node_name);
pub_image_obj_tracked =robotics.ros.Publisher(node, pub_topic, 'autoware_msgs/image_obj_tracked');
sub_image_obj_ranged = robotics.ros.Subscriber(node, sub_topic, 'autoware_msgs/image_obj_ranged', @callback_image_obj_ranged);


function callback_image_obj_ranged(~, image_objects_msg)
    global pub_image_obj_tracked
    
    msg = rosmessage('autoware_msgs/image_obj_tracked');
    msg.Header = image_objects_msg.Header;
    msg.Type = image_objects_msg.Type;
    msg.RectRanged = image_objects_msg.Obj;
    num = size(image_objects_msg.Obj);
    msg.TotalNum = num(1);
    for i = 1 : msg.TotalNum
        msg.ObjId(i) = i;
        msg.RealData(i) = 0;
        msg.Lifespan(i) = 45;
    end
    send(pub_image_obj_tracked, msg);
end