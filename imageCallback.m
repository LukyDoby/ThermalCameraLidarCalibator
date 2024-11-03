function imageCallback(msg)
    
     % Convert ROS 2 Image message to MATLAB image
    img = rosReadImage(msg);

    % Display the image
    imshow(img);
    title("Camera Image from /camera/image_raw");
    drawnow;  % Refresh the figure to display the latest image

end