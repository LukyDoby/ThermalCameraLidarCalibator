%% Camera calibration
clear; clc; close all;

% Create a set of calibration images.
images = fullfile("/home/lukas/ros2_try/bag_processing/10_9_24_im_ptCloud/data_for_calibration/images/");
images = imageDatastore(images);
imageFileNames = images.Files;
%imageFileNamesUsed = [imageFileNames(1); imageFileNames(100); imageFileNames(200)];

% Detect calibration pattern.
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

% Generate world coordinates of the corners of the squares.
squareSize = 100; % millimeters
worldPoints = generateWorldPoints(boardSize, squareSize);

% Calibrate the camera.
I = readimage(images, 1); 
imageSize = [size(I, 1), size(I, 2)];
[params, ~, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
                                     ImageSize=imageSize);

figure; 
showExtrinsics(params, "CameraCentric");