%% Backprojection of 2D points to rays in 3D
clear; clc; close all;

cloudDir = dir('/home/lukas/ros2_try/bag_processing/26_11_24_thermal_1/data_for_calibration/clouds/');

maxDistance = 0.01;
numIter = 200;
x_max = -0.5;
x_min = -2;
y_min = -1.6;
y_max = 1.2;
z_min = -0.2;
z_max = 1;

for i = 3:length(cloudDir)
    cloud = pcread(strcat(cloudDir(i).folder, '/', cloudDir(i).name));
    cloudOut = planeDetection(cloud, maxDistance,numIter ,x_min, x_max, y_min, y_max, z_min, z_max);
    pcshow(cloudOut);
    close all;

end