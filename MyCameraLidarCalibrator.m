%% My Camera Lidar Calibrator
% clearvars -except intrinsics_toolbox tform_toolbox; 
clear;
clc; close all;

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
corners_2D = [];
corners_3D_final = [];

for i = 1:length(imageFileNames)
    im = imread(imageFileNames{i}); 
    [imagePoints,boardSize] = detectCheckerboardPoints(im);
    corners = ExrtactCornersFromImage(imagePoints, boardSize,im);
    corners = flip(corners);
    corners_3D = myEstimate3DCorners(corners, boardSize, intrinsic,square_size);
    [imageCorners3d,checkerboardDimension,dataUsed] = estimateCheckerboardCorners3d(imageFileNames{i},intrinsic,100);
    corners_3D = [corners_3D(1,:); corners_3D(3,:); corners_3D(4,:); corners_3D(2,:)];
    % corners_3D
    % imageCorners3d
    % delta_cm = (abs(corners_3D - imageCorners3d)).*100
    clc;
    corners_2D(:,:,i) = corners;
    corners_3D_final(:,:,i) = corners_3D;
    
    imshow(im); hold on; plot(corners(:,1), corners(:,2), 'r+');
    hold off;
    close all;
end

%% Detect the checkerboard planes in the filtered point clouds using the plane parameters planeDimension.
planeDimension = [boardSize(1)*square_size boardSize(2)*square_size];
[lidarCheckerboardPlanes,framesUsed] = detectRectangularPlanePoints( ...
pcFileNames,planeDimension,'RemoveGround',true);

%% Extract the images, checkerboard corners, and point clouds in which you detected features.

%imagFileNames = imageFileNames(imagesUsed);
imageFileNames = imageFileNames(framesUsed);
pcFileNames = pcFileNames(framesUsed);
corners_3D_final = corners_3D_final(:,:,framesUsed);

%% Estimate Transformation

[tform,errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
corners_3D_final,intrinsic);

%% Fuse camera to Lidar
im = imread(imageFileNames{1});
cloud = pcread(pcFileNames{1});
%pcOut = fuseCameraToLidar(im,cloud,intrinsic,tform);
cloud_out = myFuseCameraLidar(im,cloud, intrinsic, tform);
pcshow(cloud_out);


%% Display translation, rotation, and reprojection errors as bar graphs.
% 
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