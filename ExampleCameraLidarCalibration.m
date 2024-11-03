%% My camera-lidar calibrator

clearvars -except tform errors; clc; close all;

%% Load images and point cloud data into the workspace.

imagePath = fullfile('/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/images/used_data/');
imds = imageDatastore(imagePath);
imageFileNames = imds.Files;
ptCloudFilePath = fullfile('/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/clouds/data_used/');
pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
pcFileNames = pcds.Files;

%% Load camera calibration files into the workspace

load('/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/cameraParams_10_11_24.mat');
params = cameraParams;
intrinsic = params.Intrinsics;

square_size = 100;
%% Estimate the checkerboard corner coordinates for the images.

[imageCorners3d,planeDimension,imagesUsed] = estimateCheckerboardCorners3d( ...
    imageFileNames,intrinsic,square_size);


pcFileNames = pcFileNames(imagesUsed);

%% Detect the checkerboard planes in the filtered point clouds using the plane parameters planeDimension.

[lidarCheckerboardPlanes,framesUsed] = detectRectangularPlanePoints( ...
pcFileNames,planeDimension,'RemoveGround',true);

%% Extract the images, checkerboard corners, and point clouds in which you detected features.

imagFileNames = imageFileNames(imagesUsed);
imageFileNames = imageFileNames(framesUsed);
pcFileNames = pcFileNames(framesUsed);
imageCorners3d = imageCorners3d(:,:,framesUsed);

%% Estimate Transformation

[tform_matlab,errors_matlab] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
imageCorners3d,intrinsic);


%% Display translation, rotation, and reprojection errors as bar graphs.

figure
bar(errors_matlab.TranslationError)
xlabel('Frame Number')
title('Translation Error (meters)')

figure
bar(errors_matlab.RotationError)
xlabel('Frame Number')
title('Rotation Error (degrees)')

figure
bar(errors_matlab.ReprojectionError)
xlabel('Frame Number')
title('Reprojection Error (pixels)')