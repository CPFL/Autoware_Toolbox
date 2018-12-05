global pub_fog_rectification;


node = robotics.ros.Node('fog_rectification_ml');
pub_fog_rectification =robotics.ros.Publisher(node, '/image_raw/rec_fog', 'sensor_msgs/Image');
sub = robotics.ros.Subscriber(node, '/image_raw', 'sensor_msgs/Image', @callback_fog_rectification);

function callback_fog_rectification(~, image_source)
    global pub_fog_rectification
    
    image_fog = readImage(image_source);
    image_rect = fog_rectification(image_fog);
    
    msg = rosmessage('sensor_msgs/Image');
    msg.Encoding = 'rgb8';
    writeImage(msg, image_rect);
    send(pub_fog_rectification, msg);
end