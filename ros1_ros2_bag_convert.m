clear; clc; close all;

% Load the ROS 1 bag file
bag1 = rosbag('/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1_2024-12-17-11-25-33.bag');
imageBag = select(bag1,'Topic',"/pylon_camera_node/image_raw");
imageMsgs = readMessages(imageBag);

% List all topics in the bag
topicList = bag1.AvailableTopics;

% Select a topic (replace with your topic name)
topic = '/pylon_camera_node/image_raw';

% Read messages from the topic
msgs = readMessages(bag1, 'DataFormat', 'struct');

% Display message details
disp(msgs{1});

% Create a new ROS 2 bag file
ros2BagWriter = ros2bagwriter('/media/lukas/T9/Dobrovolny/17_12_24_bags/checker1_ros2bag');

% Loop through messages and convert them
for i = 1:length(imageMsgs)
    img_msg = imageMsgs{i};
    % Convert ROS 1 message to ROS 2 format (if necessary)
    ros2_msg = ros2message('sensor_msgs/Image'); % Adjust the message type
    ros2_msg.data = img_msg.Data; % Modify according to your message type
    ros2_msg.height = uint32(1200);
    ros2_msg.width = uint32(1920);
    ros2_msg.encoding = img_msg.Encoding;

     if isfield(msgs{i}, 'Header') && isfield(msgs{i}.Header, 'Stamp')
        sec = int64(msgs{i}.Header.Stamp.Sec);  % Convert to int64
        nsec = int64(msgs{i}.Header.Stamp.Nsec);
        
        % Convert timestamp to [sec, nsec] format required by write()
        ros2_time = [sec, nsec];  
        time = ros2time(sec,nsec);
     end
     ros2_msg.header.frame_id = 'pylon_camera';
     % ros2_msg.header.stamp.sec = int32(sec);
     % ros2_msg.header.stamp.nanosec = uint32(nsec);

     ros2_msg.step = img_msg.Step;
     ros2_msg.header.stamp.sec = int32(img_msg.Header.Stamp.Sec);
     ros2_msg.header.stamp.nanosec = uint32(img_msg.Header.Stamp.Nsec);

    % ros2_time = ros2time(bag1.MessageList.Time(i));
    % Write the message to ROS 2 bag
    % write(ros2BagWriter, topic,ros2_msg);
     write(ros2BagWriter, topic,time,ros2_msg);
end

% Close the bag writer
delete(ros2BagWriter);
