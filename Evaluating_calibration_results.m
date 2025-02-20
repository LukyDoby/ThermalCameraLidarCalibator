%% Comapering accuracny of fusion algorithms (sphere vs checkerboard)
clear; clc; close all;

%% Loading data and calibration resuts

imagePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1/data_for_calibration/images/');
imds = imageDatastore(imagePath);
imageFileNames = imds.Files;
ptCloudFilePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1/data_for_calibration/clouds/');
pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
pcFileNames = pcds.Files;

load('/media/lukas/T9/Dobrovolny/17_12_24_bags/sphere1/centers_4_1_25.mat')  % loading sphere calib results
load('/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1/calibration_result_1_16_25.mat')  % loading checkerboard calib results

load('camera_params_RGB_12_14_24.mat');
params = cameraParams;
intrinsic = params.Intrinsics;

squareSize = 42.5;

%% Estimating corners of the checkerboard

padding_me = [106 93 109 101];

[imageCorners3d,checkerboardDimension,dataUsed] = ...
    estimateCheckerboardCorners3d(imageFileNames,intrinsic,squareSize,"Padding",padding_me);


% Remove image files that are not used.
imageFileNames = imageFileNames(dataUsed);
pcFileNames = pcFileNames(dataUsed);

%% Detect lidar checkerboard plane

maxDistance = 0.01;
numIter = 200;

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

    cloudOut = planeDetection(cloud, maxDistance,numIter ,x_min, x_max, y_min, y_max, z_min, z_max);
    % pcshow(cloudOut);
    %lidarCheckerboardPlanes(i) = pointCloud(brushedData);
    lidarCheckerboardPlanes(i) = cloudOut;
    % clear brushedData;    
end

%% Percision of the fusion checkerboard
checkerboard_fusion_percentage = [];
for i = 1:length(lidarCheckerboardPlanes)
    cloud = lidarCheckerboardPlanes(i);
    im = imread(imageFileNames{i});
    [coords, im_out] = myFuseCameraLidarThermalPlane(im,cloud, intrinsic, tform);
    % imshow(im); hold on;
    if ~isempty(coords)
        % plot(coords(:,1), coords(:,2), 'r+');
      checkerboard_fusion_percentage(1,end+1) = computeNumOfProjectedPts(im, coords, imageCorners3d(:,:,i),intrinsic);
    end
    close all;
end
checker_mean = mean(checkerboard_fusion_percentage);

%% Percision of fusion sphere

[a_0, a_1, A_0, A_1, a_x, a_y] = computeConstantsForSpehreFusion(ptImCentersCell);
sphere_fusion_percentage = [];
for i = 1:length(lidarCheckerboardPlanes)
    cloud = lidarCheckerboardPlanes(i);
    im = imread(imageFileNames{i});
    coords = myFuseCameraLidarSpehre(im,cloud,a_x,a_y,a_0,a_1,A_0, A_1);
    % imshow(im); hold on;
    if ~isempty(coords)
        % plot(coords(:,1), coords(:,2), 'r+');
        sphere_fusion_percentage(1, end+1) = computeNumOfProjectedPts(im, coords, imageCorners3d(:,:,i),intrinsic);
    end
    close all;
end
sphere_mean = mean(sphere_fusion_percentage);

%% plotting results

% checkerboard

figure(1);
bar(checkerboard_fusion_percentage);
hold on;
yline(checker_mean, 'r--', 'LineWidth', 2);
x_pos = length(checkerboard_fusion_percentage) / 2;  % Center the text
y_pos = checker_mean - 0.5;  % Slightly below the mean line
text(x_pos, y_pos, sprintf('Mean: %.3f', checker_mean), ...
    'HorizontalAlignment', 'center', 'Color', 'red', ...
    'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', 'white', ...
    'EdgeColor', 'black', 'LineWidth', 1.5, 'Margin', 5);

title('Precision of fusion using checkerboard')
xlabel('image number');
ylabel('precision of fusion [%]')

% spehre

figure(2);
bar(sphere_fusion_percentage);
hold on;
yline(sphere_mean, 'r--', 'LineWidth', 2);
x_pos = length(sphere_fusion_percentage) / 2;  % Center the text
y_pos = sphere_mean - 0.5;  % Slightly below the mean line
text(x_pos, y_pos, sprintf('Mean: %.3f', sphere_mean), ...
    'HorizontalAlignment', 'center', 'Color', 'red', ...
    'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', 'white', ...
    'EdgeColor', 'black', 'LineWidth', 1.5, 'Margin', 5);
title('Precision of fusion using spehre')
xlabel('image number');
ylabel('precision of fusion [%]')