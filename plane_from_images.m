%% Get the plane eqiation from image data
clearvars -except cameraParams_9_25_24; clc; close all;

%% Load images, clouds, intrinsics, ...
addpath('/home/lukas/ros2_try/bag_processing/MyCameraLidarCalibrator')
imagePath = fullfile("/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/images");
load("/home/lukas/ros2_try/bag_processing/checkerboard_09_25/results.mat");
camera_intrinsics = intrinsics;

% Load calibration session 
load('/home/lukas/ros2_try/bag_processing/checkerboard_09_25/lccSession_9_25_24.mat');

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
%ims_used = {calibrationSession.Datapairs.ImageFile};
corners2D = cell(length(imds.Files),2); % cell to store checker corners
worldPoses = cell(length(imds.Files),1);

%worldPoints = [0,0 0; 0, 5*squareSize 0; 8*squareSize, 0 0; 8*squareSize, 5*squareSize 0];
for i = 1:length(imds.Files)
    im = imread(imds.Files{i});
    [imagePoints,boardSize] = detectCheckerboardPoints(im);
    corners = ExrtactCornersFromImage(imagePoints, boardSize,im);
    corners2D{i,1} = corners;
    corners2D{i,2} = imagePoints;
    % imshow(im); hold on; plot(corners(:,1), corners(:,2), 'r+')
    % close all;

    %% Estimating 3D corners
    worldPoints = generateWorldPoints([5,8], 100);
    worldPose = estworldpose(undistortPoints(imagePoints,intrinsics),worldPoints,intrinsics);
    camExtrinsics = estimateExtrinsics(imagePoints, worldPoints, intrinsics);
    worldPoses{i,1} = rotationMatrix;
end


