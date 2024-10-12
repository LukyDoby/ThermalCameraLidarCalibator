%% ray plane intersection
clear; clc; close all

load('/home/lukas/ros2_try/bag_processing/10_9_24_im_ptCloud/camera_intrinsic.mat');
imagePath = fullfile("/home/lukas/ros2_try/bag_processing/10_9_24_im_cloud_rotated_board/Images/");
cloudPath = fullfile('/home/lukas/ros2_try/bag_processing/10_9_24_im_cloud_rotated_board/PointClouds/');
K = camera_intrinsic.K;

%% detecting checkerboard points

im = imread(fullfile(imagePath,"0009.png"));
cloud = pcread(fullfile(cloudPath,'0009.pcd'));

[imagePoints,boardSize] = detectCheckerboardPoints(im);
square_size = 100;
worldPoints = generateWorldPoints(boardSize,square_size);

%% Estimating extrinsics

camExtrinsics = estimateExtrinsics(imagePoints,worldPoints,camera_intrinsic);
R = camExtrinsics.R;
t = camExtrinsics.Translation;
t = t';

%% Compute plane from image 

% Normal vector in world coordinates (XY-plane normal)
normal_world = [0; 0; 1];

% Compute normal vector in camera coordinates (apply rotation)
n_camera = R * normal_world;

% Compute plane offset in camera coordinates (distance from camera to plane)
d_camera = dot(n_camera, t);  % t is the translation from world to camera

% Create a grid of points for the XY-plane in camera coordinates
[X, Y] = meshgrid(-20000:100:20000, -30000:100:30000);  % Adjust grid limits as needed

% Compute Z values based on the plane equation (solve for Z in camera frame)
Z = (d_camera - n_camera(1)*X - n_camera(2)*Y) / n_camera(3);
points3D = [X(:), Y(:), Z(:)];

%% compute the intersection
imgPoint = [imagePoints(1,:)'; 1];
normalized_point = K \ imgPoint;

% Step 2: Transform into camera coordinates
ray_dir = R' * (normalized_point - t);  % Direction of ray in 3D

% Step 3: Compute the camera center in world coordinates
C = -R' * t;  % Camera center

% Step 4: Compute intersection of the ray with the plane
lambda = (d_camera - dot(n_camera, C)) / dot(n_camera, ray_dir);

% Step 5: Compute the 3D intersection point
X_intersect = C + lambda * ray_dir;

%% plotting results

plot3(X,Y,Z,'r+');
