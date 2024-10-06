%% My camera-lidar calibrator

clear; clc; close all;

%% Load images, clouds, intrinsics, ...
addpath("/home/lukas/ros2_try/bag_processing")
imagePath = fullfile("/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/images/");
ptCloudPath = fullfile("/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/clouds/");
% camera intrinsics
load("/home/lukas/ros2_try/bag_processing/checkerboard_09_25/results.mat");
camera_intrinsics = intrinsics;

imds = imageDatastore(imagePath);
imageFileNames = imds.Files;

pcds = fileDatastore(ptCloudPath,'ReadFcn',@pcread);
ptCloudFileNames = pcds.Files;

% Square size of the checkerboard.
squareSize = 100;

%% Detect checkerboard corners

[imageCorners3d,checkerboardDimension,dataUsed] = ...
    estimateCheckerboardCorners3d(imageFileNames,camera_intrinsics,squareSize);

imageFileNames = imageFileNames(dataUsed);
helperShowImageCorners(imageCorners3d,imageFileNames,intrinsics)

%% Detect checkerboard plane

% Extract the checkerboard ROI from the detected checkerboard image corners.
roi = helperComputeROI(imageCorners3d,5);

% Filter the point cloud files that are not used for detection.
ptCloudFileNames = ptCloudFileNames(dataUsed);
[lidarCheckerboardPlanes,framesUsed,indices] = ...
    detectRectangularPlanePoints(ptCloudFileNames,checkerboardDimension,ROI=roi);

% Remove ptCloud files that are not used.
ptCloudFileNames = ptCloudFileNames(framesUsed);

% Remove image files.
imageFileNames = imageFileNames(framesUsed);

% Remove 3-D corners from images.
imageCorners3d = imageCorners3d(:,:,framesUsed);


