%% Backprojection of 2D points to rays in 3D
clear; clc; close all;

load('/home/lukas/ros2_try/bag_processing/checkerboard_09_25/cameraCalibrationSession.mat');
intrinsic = calibrationSession.CameraParameters.Intrinsics;
extrinsic = calibrationSession.CameraParameters.PatternExtrinsics;

imagePath = fullfile("/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/images");

imds = imageDatastore(imagePath);
imageFileNames = imds.Files;


% Square size of the checkerboard.
squareSize = 100;

%% detect checkerboard points 
im = imread(imageFileNames{1});
[imagePoints,boardSize] = detectCheckerboardPoints(im);

%% K is the intrinsic matrix
% imgPoints is a Nx2 matrix of image points
 K = intrinsic.K;
% normalized_points = inv(K) * [imagePoints'; ones(1, size(imagePoints, 1))];


% Compute rays in camera coordinates
R = extrinsic(1,1).R;
t = extrinsic(1,1).Translation;
t = t';
imgPoint = imagePoints(1,:);
imgPoint = [imgPoint'; 1];
normalized_point = K \ imgPoint;
ray_dir = R' * (normalized_point - t);

%rays = R' * (normalized_points - t');  % Direction of rays in 3D

%% Compute n and d of checkerboard plane
worldPoints = calibrationSession.CameraParameters.WorldPoints;
worldPoints(:,end+1) = zeros(length(worldPoints),1);
n = R(:,3);
d = dot(n,t);

%% Intersect ray with the plane
% n is the normal vector of the checkerboard plane
% d is the offset of the plane from the origin
C = -R' * t;  % Camera center in world coordinates

% Preallocate for 3D intersection points
% Step 4: Compute the intersection of the ray with the plane
% lambda (scalar) = (d - dot(n, C)) / dot(n, ray_dir)
lambda = (d - dot(n, C)) / dot(n, ray_dir);
% lambda computation may result in infinity if ray_dir = [0; 0; 0], in practice, ray_dir should be non-zero.

% Step 5: Compute the 3D intersection point
% X_intersect (3x1) = C (3x1) + lambda * ray_dir (3x1)
X_intersect = C + lambda * ray_dir;

% % Visualize 3D points
% plot3(intersect_points(1, :), intersect_points(2, :), intersect_points(3, :));
% xlabel('X'), ylabel('Y'), zlabel('Z');
% grid on;
