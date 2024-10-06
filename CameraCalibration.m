%% Camera calibration
clear; clc; close all;

% Create a set of calibration images.
images = fullfile("/home/lukas/ros2_try/bag_processing/only_checkerboard_10_6_24/Images");
images = imageDatastore(images);
imageFileNames = images.Files;
imageFileNamesUsed = [imageFileNames(1); imageFileNames(100); imageFileNames(200)];

% Detect calibration pattern.
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNamesUsed);

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