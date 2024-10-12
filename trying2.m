%% Backprojection of 2D points to rays in 3D
clear; clc; close all;

load('/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/cameraParams_10_11_24.mat');
params = cameraParams;
intrinsic = params.Intrinsics;
extrinsic = params.PatternExtrinsics;

imagePath = fullfile("/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/data_for_calibration/images/");
cloudPath = fullfile('/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/PointClouds/');

idx = 10;
R = extrinsic(idx,1).R;
t = extrinsic(idx,1).Translation;
t = t';
K = intrinsic.K;


im = imread(fullfile(imagePath,"0204.png"));
cloud = pcread(fullfile(cloudPath,'0204.pcd'));
[imagePoints,boardSize] = detectCheckerboardPoints(im);

% Normal vector in world coordinates (XY-plane normal)
normal_world = [0; 0; 1];

% Compute normal vector in camera coordinates (apply rotation)
n_camera = R* normal_world;

% Compute plane offset in camera coordinates (distance from camera to plane)
d_camera = dot(n_camera, t);  % t is the translation from world to camera

% Create a grid of points for the XY-plane in camera coordinates
[X, Y] = meshgrid(-400:50:400, -300:50:0);  % Adjust grid limits as needed

% Compute Z values based on the plane equation (solve for Z in camera frame)
Z = (d_camera - n_camera(1)*X - n_camera(2)*Y) / n_camera(3);
points3D = [X(:), Y(:), Z(:)];
%% transform points3D to Extrinsic coordinates 
points3D = points3D';
%points3D_extr = points3D;
% points3D = rotz(180) * points3D;
% points3D = rotz(180)*points3D;
points3D_extr = rotx(90)*points3D;
points3D_extr = rotz(180)*points3D_extr;

%points3D_extr = [-1 0 0; 0 -1 0; 0 0 -1]*points3D ; 
%%
showExtrinsics(params); hold on;%%
plot3(points3D_extr(1,:),points3D_extr(2,:),points3D_extr(3,:), 'r+', 'MarkerSize',1); axis equal
hold on; xlabel('X'); ylabel('Y'); zlabel('Z');
%% tranform points3D extrinsic to point cloud coordinates

points3D_extr = rotz(-90)*points3D_extr ;
%points3D_cloud = points3D_extr * rotz(90);
points3D_cloud = [1 0 0; 0 1 0; 0 0 -1]*points3D_extr;
points3D_cloud = points3D_cloud./1000;


plot3(points3D_cloud(1,:),points3D_cloud(2,:),points3D_cloud(3,:), 'r+', 'MarkerSize',1); axis equal
hold on; xlabel('X'); ylabel('Y'); zlabel('Z');
hold on; pcshow(cloud)

%%
X  = X./1000;
Y = Y./1000;
Z = Z./1000;

pcshow(cloud); hold on; xlabel('X'); ylabel('Y'); zlabel('Z');
axis equal
plot3(X,Y,Z,'ro');



% Step 4: Compute the intersection of the ray with the plane
% lambda (scalar) = (d - dot(n, C)) / dot(n, ray_dir)
lambda = (d_camera - dot(n_camera', C)) / dot(n_camera', ray_dir);
% lambda computation may result in infinity if ray_dir = [0; 0; 0], in practice, ray_dir should be non-zero.

% Step 5: Compute the 3D intersection point
% X_intersect (3x1) = C (3x1) + lambda * ray_dir (3x1)
X_intersect = C + lambda * ray_dir;

X_ray = C + linspace(0,100,100) .* ray_dir;
figure;
showExtrinsics(params);
hold on;
plot3(X_ray(:,1),X_ray(:,2),X_ray(:,3),'r-')
%plot3(X_intersect(1),X_intersect(3),X_intersect(2), 'r+')