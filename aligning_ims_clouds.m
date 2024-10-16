%% alignning image and point cloud using calibrated camera
clear; clc; close all

load('/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/cameraParams_10_11_24.mat');
params = cameraParams;
intrinsic = params.Intrinsics;
extrinsic = params.PatternExtrinsics;

imagePath = fullfile("/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/Images/");
cloudPath = fullfile('/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/PointClouds/');

%% detecting checkerboard points

im = imread(fullfile(imagePath,"0158.png"));
cloud = pcread(fullfile(cloudPath,'0158.pcd'));

[imagePoints,boardSize] = detectCheckerboardPoints(im);
square_size = 100;
worldPoints = generateWorldPoints(boardSize,square_size);

%% Estimating extrinsics

camExtrinsics = estimateExtrinsics(imagePoints,worldPoints,intrinsic);
R = camExtrinsics.R;
t = camExtrinsics.Translation;
t = t';
K = params.K;
%% Compute plane from image 

% Normal vector in world coordinates (XY-plane normal)
normal_world = [0; 0; 1];

% Compute normal vector in camera coordinates (apply rotation)
n_camera = R * normal_world;

% Compute plane offset in camera coordinates (distance from camera to plane)
d_camera = dot(n_camera, t);  % t is the translation from world to camera

% Create a grid of points for the XY-plane in camera coordinates
[X, Y] = meshgrid(-400:50:400, -300:50:0);  % Adjust grid limits as needed

% Compute Z values based on the plane equation (solve for Z in camera frame)
Z = (d_camera - n_camera(1)*X - n_camera(2)*Y) / n_camera(3);
points3D = [X(:), Y(:), Z(:)];
%% transform points3D to Extrinsic coordinates 
points3D = points3D';
points3D_cloud = transformPointsToCloudCoordinates(points3D);

%% ray plane intersection
% 
intersectPoints = [];
for i = 1: length(imagePoints)

    imgPoint = [imagePoints(i,:)'; 1];
    ray_dir = inv(K)* imgPoint;
    ray_dir = ray_dir / norm(ray_dir);    
    lambda = d_camera / dot(n_camera, ray_dir);
    X_intersect =lambda * ray_dir;
    X_intersect = transformPointsToCloudCoordinates(X_intersect);
    intersectPoints(:,end+1) = X_intersect;
 end

%% plottin results

pcshow(cloud);
%plot3(points3D_cloud(1,:),points3D_cloud(2,:),points3D_cloud(3,:), 'g+', 'MarkerSize',1); axis equal
hold on; xlabel('X'); ylabel('Y'); zlabel('Z');
plot3(intersectPoints(1,:),intersectPoints(2,:), intersectPoints(3,:), 'g+'); hold off


% plot3(ray_points(1,:), ray_points(2,:), ray_points(3,:), 'ro','MarkerSize',1);
% hold off

%% Compare 3D corners estimation
% 
corners = ExrtactCornersFromImage(imagePoints, boardSize,im);
corners3D = [];
for i = 1: length(corners)

    imgPoint = [corners(i,:)'; 1];
    ray_dir = inv(K)* imgPoint;
    ray_dir = ray_dir / norm(ray_dir);    
    lambda = d_camera / dot(n_camera, ray_dir);
    X_intersect =lambda * ray_dir;
    X_intersect = X_intersect ./ 1000;
   % X_intersect = transformPointsToCloudCoordinates(X_intersect);
    corners3D(end+1,:) = X_intersect';
end


imageFileNames = '/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/Images/0158.png';
[imageCorners3d,checkerboardDimension,dataUsed] = estimateCheckerboardCorners3d(imageFileNames,intrinsic,100);

corners3D
imageCorners3d
% corners3D = transformPointsToCloudCoordinates(corners3D');
% corners3D = corners3D .* 1000;
% %%
% pcshow(cloud);
% %plot3(points3D_cloud(1,:),points3D_cloud(2,:),points3D_cloud(3,:), 'g+', 'MarkerSize',1); axis equal
% hold on; xlabel('X'); ylabel('Y'); zlabel('Z');
% plot3(corners3D(:,1),corners3D(:,2), corners3D(:,3), 'g+'); hold off