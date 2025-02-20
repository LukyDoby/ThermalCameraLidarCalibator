%% My Camera Lidar Calibrator Real data
% clearvars -except intrinsics_toolbox tform_toolbox; 
clear;
clc; close all;

%% Load images and point cloud data into the workspace.

imagePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/checker2/data_for_calibration/images/');
imds = imageDatastore(imagePath);
imageFileNames = imds.Files;
ptCloudFilePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/checker2/data_for_calibration/clouds/');
pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
pcFileNames = pcds.Files;

%% Load camera calibration files into the workspace

load('camera_params_RGB_12_14_24.mat');
params = cameraParams;
intrinsic = params.Intrinsics;

squareSize = 42.5;

%% Estimate the checkerboard corner coordinates for the images.
padding_vedouci = [108 99 104 92];
padding_me = [106 93 109 101];

[imageCorners3d,checkerboardDimension,dataUsed] = ...
    estimateCheckerboardCorners3d(imageFileNames,intrinsic,squareSize,"Padding",padding_me);


% Remove image files that are not used.
imageFileNames = imageFileNames(dataUsed);
pcFileNames = pcFileNames(dataUsed);
%helperShowImageCorners(imageCorners3d, imageFileNames, intrinsic);

%% Detect lidar checkerboard plane

maxDistance = 0.01;
numIter = 200;
thresh = 0.03;

x_max = -0.7;
x_min = -2;
y_min = -1.5;
y_max = 1.5;
z_min = -1;
z_max = 1;

for i = 1:length(imageFileNames)
    cloud = pcread(pcFileNames{i});

    % [~,nonGroundPtCloud,~] = segmentGroundSMRF(cloud,'ElevationThreshold', 0.1);
  
    points = cloud.Location;
    points(points(:,1) < x_min, :) = [];
    points(points(:,1) > x_max, :) = [];
    points(points(:,2) < y_min, :) = [];
    points(points(:,2) > y_max, :) = [];
    points(points(:,3) < z_min, :) = [];
    points(points(:,3) > z_max, :) = [];
    cloud = pointCloud(points);
    % pcshow(cloud);
    % ptCloudA = pointCloud(brushedData);

    [cloudOut, coeffs,bestPlanePoints] = planeDetection(cloud, maxDistance,numIter ,x_min, x_max, y_min, y_max, z_min, z_max);
    % figure(1); 
    % pcshow(cloudOut);

    % cloudPtsPtojected = projectOutliersOntoPlane(cloud, coeffs, bestPlanePoints,thresh);
    % figure(2)
    % pcshow(cloudPtsPtojected);
    %lidarCheckerboardPlanes(i) = pointCloud(brushedData);
    lidarCheckerboardPlanes(i) = cloudOut;
    % clear brushedData;    
end


%% Estimate Transformation

[tform,errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
imageCorners3d,intrinsic);

%% Display translation, rotation, and reprojection errors as bar graphs.

helperShowError(errors);

%% Remove data with high errors and recalibrate
wrong = [10];
lidarCheckerboardPlanes(wrong) = [];
imageCorners3d(:,:,wrong) = [];
imageFileNames(wrong) = [];

[tform,errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
imageCorners3d,intrinsic);

%% Display translation, rotation, and reprojection errors as bar graphs.

helperShowError(errors);


%% Percision of the fusion

for i = 1:length(lidarCheckerboardPlanes)
    cloud = lidarCheckerboardPlanes(i);
    im = imread(imageFileNames{i});
    [coords, im_out] = myFuseCameraLidarThermalPlane(im,cloud, intrinsic, tform);
    imshow(im); hold on;
    if ~isempty(coords)
        plot(coords(:,1), coords(:,2), 'r+');
    end
    close all;
end

%% How accurate is the fusion?


