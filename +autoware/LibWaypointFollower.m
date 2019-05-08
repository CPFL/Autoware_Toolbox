classdef LibWaypointFollower < handle
    % LibWaypointFollower libwaypoint_follower.cpp ‚ÉŽÀ‘•‚³‚ê‚Ä‚¢‚éŠÖ”

    methods (Static)
        function rotate = rotatePoint(point, degree)
            rotate = point;
            rotate.X = cos(deg2rad(degree)) * point.X - sin(deg2rad(degree)) * point.Y;
            rotate.Y = sin(deg2rad(degree)) * point.X + cos(deg2rad(degree)) * point.Y;
        end
        
        % calculation absolute coordinate of point on current_pose frame
        function tf_point_msg = calcAbsoluteCoordinate(point_msg, current_pose)
%             tform = quat2tform(current_pose.Orientation.readQuaternion());    % Code generation not possible
            tform = quat2tform([current_pose.Orientation.W, current_pose.Orientation.X, ...
                                current_pose.Orientation.Y, current_pose.Orientation.Z]);
            tform(1, 4) = current_pose.Position.X;
            tform(2, 4) = current_pose.Position.Y;
            tform(3, 4) = current_pose.Position.Z;
            p = [point_msg.X; point_msg.Y; point_msg.Z; 1];
            tf_p = tform * p;
            tf_point_msg = point_msg;
            tf_point_msg.X = tf_p(1);
            tf_point_msg.Y = tf_p(2);
            tf_point_msg.Z = tf_p(3);            
        end        
    end
end

% [EOF]