%% My camera-lidar calibrator

clear; clc; close all;

%% Load images and point cloud data into the workspace.

imageDataPath = fullfile(toolboxdir('lidar'),'lidardata',...
    'lcc','vlp16','images');
imds = imageDatastore(imageDataPath);
imageFileNames = imds.Files;
ptCloudFilePath = fullfile(toolboxdir('lidar'),'lidardata',...
'lcc','vlp16','pointCloud');
pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
pcFileNames = pcds.Files;

%% Load camera calibration files into the workspace.

cameraIntrinsicFile = fullfile(imageDataPath,'calibration.mat');
intrinsic = load(cameraIntrinsicFile);

squareSize = 81;

%% Estimate the checkerboard corner coordinates for the images.

[imageCorners3d,planeDimension,imagesUsed] = estimateCheckerboardCorners3d( ...
    imageFileNames,intrinsic.cameraParams,squareSize);


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

[tform,errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
imageCorners3d,intrinsic.cameraParams);

%% Display translation, rotation, and reprojection errors as bar graphs.

figure
bar(errors.TranslationError)
xlabel('Frame Number')
title('Translation Error (meters)')

figure
bar(errors.RotationError)
xlabel('Frame Number')
title('Rotation Error (degrees)')

figure
bar(errors.ReprojectionError)
xlabel('Frame Number')
title('Reprojection Error (pixels)')