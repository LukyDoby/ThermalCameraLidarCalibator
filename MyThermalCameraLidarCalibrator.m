%% My Camera Lidar Calibrator
% clearvars -except intrinsics_toolbox tform_toolbox; 
clear;
clc; close all;

%% Load images and point cloud data into the workspace.

imagePath = fullfile('/home/lukas/ros2_try/bag_processing/26_11_24_thermal_2/data_for_calibration/images/');
imds = imageDatastore(imagePath);
imageFileNames = imds.Files;
ptCloudFilePath = fullfile('/home/lukas/ros2_try/bag_processing/26_11_24_thermal_2/data_for_calibration/clouds/');
pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
pcFileNames = pcds.Files;

%% Load camera calibration files into the workspace

load('calibrationSession_Boson_hlinik_final.mat');
intrinsic = calibrationSession.CameraParameters.Intrinsics;

%% Estimate the checkerboard corner coordinates for the images.
corners_2D = [];
corners_3D_final = [];
thresh = 180;
boardSize = [249 386];

maxDistance = 0.01;
numIter = 200;
x_max = -0.5;
x_min = -2;
y_min = -1.6;
y_max = 1.2;
z_min = -0.2;
z_max = 1;

for i = 1:length(imageFileNames)
    im = imread(imageFileNames{i}); 
    [corners, im_undist] = thermalImageProcessing(im,thresh, intrinsic);
    imshow(im_undist); hold on; plot(corners(:,1), corners(:,2), 'r+');
    %% Split corners
    sorted_by_x = sortrows(corners, 1);
    sorted_by_y = sortrows(corners,2);

    LH = sorted_by_y(1,:);
    LD = sorted_by_x(1,:);
    PH = sorted_by_x(end,:);
    PD = sorted_by_y(end,:);

    corners = [LH; LD; PH; PD];
 
    corners_3D = myEstimateThermal3DCorners(corners, boardSize, intrinsic);
    corners_3D = [corners_3D(1,:); corners_3D(3,:); corners_3D(4,:); corners_3D(2,:)];
    corners_2D(:,:,i) = corners;
    corners_3D_final(:,:,i) = corners_3D;

    cloud = pcread(pcds.Files{i});
    cloudOut = planeDetection(cloud, maxDistance,numIter ,x_min, x_max, y_min, y_max, z_min, z_max);
    pcshow(cloudOut);
    lidarCheckerboardPlanes(i) = pointCloud(brushedData);
    clear brushedData;

    close all;
end

%% Checking data

for i = 1:length(lidarCheckerboardPlanes)
    im = imread(imageFileNames{i});
    im_undist = undistortImage(im,intrinsic);
    imshow(im_undist); hold on; plot(corners_2D(:,1,i), corners_2D(:,2,i), 'r+');
    close all;
    pcshow(lidarCheckerboardPlanes(i));
    close all;
end


%% Estimate Transformation
%load('/home/lukas/ros2_try/bag_processing/26_11_24_thermal_1/corners_and_planes.mat')

[tform,errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
corners_3D_final,intrinsic);

%% Fuse camera to Lidar
% im = imread(imageFileNames{1});
% cloud = pcread(pcFileNames{1});
% %pcOut = fuseCameraToLidar(im,cloud,intrinsic,tform);
% cloud_out = myFuseThermalCameraLidar(im,cloud, intrinsic, tform);
% pcshow(cloud_out);

%% Percision of the fusion

for i = 1:length(lidarCheckerboardPlanes)
    cloud = lidarCheckerboardPlanes(i);
    im = imread(imageFileNames{i});
    [coords, im_out] = myFuseCameraLidarThermalPlane(im,cloud, intrinsic, tform);
    imshow(im_out); hold on;
    if ~isempty(coords)
        plot(coords(:,1), coords(:,2), 'r+');
    end
    close all;
end
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

