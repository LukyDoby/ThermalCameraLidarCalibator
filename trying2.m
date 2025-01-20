%% Backprojection of 2D points to rays in 3D
clear; clc; close all;

cloud = pcread("/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1/PointClouds/0119.ply");
im = imread("/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1/Images/0119.png");
load("/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1/calibration_result_1_16_25.mat");


maxDistance = 0.02;
numIter = 200;

x_max = -0.5;
x_min = -3;
y_min = -1.5;
y_max = 1.5;
z_min = -1;
z_max = 1.8;

cloudOut = planeDetection(cloud, maxDistance,numIter ,x_min, x_max, y_min, y_max, z_min, z_max);

[coord, im_out] = myFuseCameraLidarThermalPlane(im,cloudOut, intrinsic, tform);
imshow(im); hold on;

plot(coord(:,1), coord(:,2), 'r+');