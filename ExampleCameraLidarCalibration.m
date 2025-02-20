%% My camera-lidar calibrator
clear; clc; close all;

%% Load images and point cloud data into the workspace.

imagePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/sphere3/simulator/checkerboard/data_for_calibration/images/');
imds = imageDatastore(imagePath);
imageFileNames = imds.Files;
ptCloudFilePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/sphere3/simulator/checkerboard/data_for_calibration/clouds/');
pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
pcFileNames = pcds.Files;

%% Load camera calibration files into the workspace

load("/home/lukas/ros2_humble/camera_calib_intrinsics/gazebo_camera_params.mat");
cameraParams = params;
intrinsic = cameraParams.Intrinsics;

square_size = 50;
%% Estimate the checkerboard corner coordinates for the images.

[imageCorners3d,planeDimension,dataUsed] = estimateCheckerboardCorners3d( ...
    imageFileNames,intrinsic,square_size);

imageFileNames = imageFileNames(dataUsed);
pcFileNames = pcFileNames(dataUsed);

%% Detect the checkerboard planes in the filtered point clouds using the plane parameters planeDimension.

[lidarCheckerboardPlanes,framesUsed] = detectRectangularPlanePoints( ...
pcFileNames,planeDimension,'RemoveGround',true);

%% Extract the images, checkerboard corners, and point clouds in which you detected features.

imagFileNames = imageFileNames(framesUsed);
imageFileNames = imageFileNames(framesUsed);
pcFileNames = pcFileNames(framesUsed);
imageCorners3d = imageCorners3d(:,:,framesUsed);

%% Estimate Transformation

[tform,errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
imageCorners3d,intrinsic);


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

%% Remove data with high errors and recalibrate
wrong = 17;
lidarCheckerboardPlanes(wrong) = [];
imageCorners3d(:,:,wrong) = [];
imageFileNames(wrong,:) = [];
pcFileNames(wrong,:) = [];

[tform,errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
imageCorners3d,intrinsic);

%% Percision of the fusion

for i = 1:length(imageFileNames)
    cloud = lidarCheckerboardPlanes(i);
    % cloud = pcread(pcFileNames{i});
    im = imread(imageFileNames{i});
    [coords, im_out] = myFuseCameraLidarThermalPlane(im,cloud, intrinsic, tform);
    imshow(im); hold on;
    if ~isempty(coords)
        plot(coords(:,1), coords(:,2), 'r+');
    end
    close all;
end
