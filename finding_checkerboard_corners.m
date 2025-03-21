%% Finding checkerboard corners
clear; clc; close all;

%% Loading params
im = imread("/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker3/data_for_calibration/images/0127.png");
load("camera_params_RGB_12_14_24.mat");
intrinsic = cameraParams.Intrinsics;
padding = [106 93 109 101];

%% Detecting checkerboard
im_undist = undistortImage(im, intrinsic);
[imagePoints,boardSize] = detectCheckerboardPoints(im_undist);

%% Estimating camera pose

squareSize = 42.5;
%squareSize = 1;
my_worldPoints = generateCheckerboardWorldPoints(squareSize, boardSize);
worldPoints = patternWorldPoints("checkerboard",boardSize,squareSize);

camExtrinsics = estimateExtrinsics(imagePoints,worldPoints,intrinsic);
% tform = estworldpose(imagePoints,my_worldPoints,intrinsic);

%% Calculate wolrd points of checkerboard plane

LH_wrld = [worldPoints(1,1)-squareSize - padding(1), worldPoints(1,2) - squareSize - padding(2)];
LD_wrld = [worldPoints(boardSize(1)-1,1)-squareSize - padding(1), worldPoints(boardSize(1)-1,2) + squareSize + padding(4)];
PH_wrld = [worldPoints(((boardSize(1)-1)*(boardSize(2)-1)-boardSize(1)+2),1)+squareSize + padding(3), worldPoints(((boardSize(1)-1)*(boardSize(2)-1)-boardSize(1)+2),2) - squareSize - padding(2)];
PD_wrld = [worldPoints((boardSize(1)-1)*(boardSize(2)-1),1)+squareSize + padding(3), worldPoints((boardSize(1)-1)*(boardSize(2)-1),2)+squareSize+padding(4)];

corners_wrld = [LH_wrld 0; LD_wrld 0; PH_wrld 0; PD_wrld 0];
%% Project 3D points onto a image plane
d = size(im);
rows = d(1);
cols = d(2);

% [projected] = projectPoints(worldPoints, intrinsic.K, tform.A, intrinsic.RadialDistortion, [rows cols],true);
imagePoints = world2img(corners_wrld,camExtrinsics,intrinsic);

%% Finding bboxes of desk corners

boxSize = 70;  % 50x50 boxes

% Compute bounding boxes
bboxes = computePointBoundingBoxes(imagePoints, [d(1), d(2)], boxSize);

%% Apply image processing methods to detect desk corners

% for i = 1:length(bboxes)
%     im_cropped = imcrop(im_undist, bboxes(i,:));
%     corner = localCornerImageProcessing(im_cropped);
% end

% Visualize
imshow(im_undist); hold on;
plot(imagePoints(:,1), imagePoints(:,2), 'ro', 'MarkerFaceColor', 'r');
for i = 1:size(bboxes, 1)
    rectangle('Position', bboxes(i, :), 'EdgeColor', 'g', 'LineWidth', 2);
end
title('Bounding Boxes Around Points');