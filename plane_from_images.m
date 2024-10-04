%% Get the plane eqiation from image data
clear; clc; close all;

%% Load images, clouds, intrinsics, ...
addpath('/home/lukas/ros2_try/bag_processing/MyCameraLidarCalibrator')
imagePath = fullfile("/home/lukas/ros2_try/bag_processing/MyCameraLidarCalibrator/checkerboard_09_25/data_for_calibration/images");
load("/home/lukas/ros2_try/bag_processing/MyCameraLidarCalibrator/checkerboard_09_25/results.mat");
camera_intrinsics = intrinsics;

imds = imageDatastore(imagePath);
imageFileNames = imds.Files;


% Square size of the checkerboard.
squareSize = 100;

%% Detect checkerboard corners Matlab functions

% [imageCorners3d,checkerboardDimension,dataUsed] = ...
%     estimateCheckerboardCorners3d(imageFileNames,camera_intrinsics,squareSize);
% 
% imageFileNames = imageFileNames(dataUsed);
% 
% helperShowImageCorners(imageCorners3d,imageFileNames, intrinsics)

%% Detect checkerboard corners

for i = 1:length(imds.Files)
    im = imread(imds.Files{i});
    [imagePoints,boardSize] = detectCheckerboardPoints(im);
    corners = ExrtactCornersFromImage(imagePoints, boardSize,im);
    imshow(im); hold on; plot(corners(:,1), corners(:,2), 'r+')
    close all;
end
