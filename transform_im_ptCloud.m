%% Transformation image -> point cloud
clear; clc; close all;

load('/media/lukas/T9/Dobrovolny/17_12_24_bags/sphere5/simulator/centers.mat');  % 1. col are medians of ptCloud centers, 2. col are medians of ptCloud radiis, 3. col are image centers
%% prolozeni MNČ primkou

ptCenters = cell2mat(ptImCentersCell(:,1));
imCenters = cell2mat(ptImCentersCell(:,3));

x_im = imCenters(:,1);
sum_x_i = sum(x_im);
sum_x_i_square = sum(x_im.^2);

y_im = imCenters(:,2); 
sum_y_i = sum(y_im);
sum_y_i_square = sum(y_im.^2);

%% Convert ptCloud to azimuth and elevation
az_elev = [];
for k = 1:length(ptCenters)
    [azim, elev] = cartesianToSpherical(ptCenters(k,1),ptCenters(k,2),ptCenters(k,3));
    az_elev(end+1,:) = [azim, elev];
end

sum_az = sum(az_elev(:,1));
sum_elev = sum(az_elev(:,2));

sum_xi_az = [];
sum_yi_elev = [];
for k = 1:length(az_elev)

    sum_xi_az(end+1) = x_im(k) * az_elev(k,1);
    sum_yi_elev(end+1) = y_im(k) * az_elev(k,2);
    

end
sum_xi_az = sum(sum_xi_az);
sum_yi_elev = sum(sum_yi_elev);

%% ziskani a_0, a_1, imgX - azimut 

A = [1 sum_x_i; sum_x_i sum_x_i_square];
b = [sum_az; sum_xi_az];
x = inv(A)*b;

a_0 = x(1);
a_1 = x(2);

%% ziskani A_0 a A_1, img_Y - elevace

A = [1 sum_y_i; sum_y_i sum_y_i_square];
b = [sum_elev; sum_yi_elev];
x = inv(A)*b;

A_0 = x(1);
A_1 = x(2);

%% Nova data

x_bar = a_0*imCenters(:,1) + a_1;
y_bar = A_0*imCenters(:,2) + A_1;

%% Solve polynomial equation

% solving for x

A = [];
b = [];
x = az_elev(:,1);       % azimuth
y = az_elev(:,2);       % elevation

for k = 1:length(az_elev)
   A(end+1,:) = [1  x(k)  y(k)  x(k)^2  x(k)*y(k)  y(k)^2  x(k)^3  x(k)^2*y(k)  x(k)*y(k)^2  y(k)^3  x(k)^4  x(k)^3*y(k)  x(k)^2*y(k)^2  x(k)*y(k)^3  y(k)^4];
    
  %A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3  x(i)^4  x(i)^3*y(i)  x(i)^2*y(i)^2  x(i)*y(i)^3  y(i)^4  x(i)^5  x(i)^4*y(i) x(i)^3*y(i)^2  x(i)^2*y(i)^3  x(i)*y(i)^4  y(i)^5];   % polynom 5. stupne
   
 % A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3];
  b(end+1,:) = x_bar(k);

end

a_x = inv(A'*A)*A'*b;

% Solving for y


A = [];
b = [];
x = az_elev(:,1);       % azimuth
y = az_elev(:,2);       % elevation

for k = 1:length(az_elev)
    A(end+1,:) = [1  x(k)  y(k)  x(k)^2  x(k)*y(k)  y(k)^2  x(k)^3  x(k)^2*y(k)  x(k)*y(k)^2  y(k)^3  x(k)^4  x(k)^3*y(k)  x(k)^2*y(k)^2  x(k)*y(k)^3  y(k)^4];
    
   % A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3  x(i)^4  x(i)^3*y(i)  x(i)^2*y(i)^2  x(i)*y(i)^3  y(i)^4  x(i)^5  x(i)^4*y(i) x(i)^3*y(i)^2  x(i)^2*y(i)^3  x(i)*y(i)^4  y(i)^5];   % polynom 5. stupne
   
  %A(end+1,:) = [1  x(i)  y(i)  x(i)^2  x(i)*y(i)  y(i)^2  x(i)^3  x(i)^2*y(i)  x(i)*y(i)^2  y(i)^3];
  b(end+1,:) = y_bar(k);

end

a_y = inv(A'*A)*A'*b;


% %% Cam Lid Fusion
% 
% pc = pcread("/media/lukas/T9/Dobrovolny/17_12_24_bags/checker2/PointClouds/0696.ply");
% im = imread("/media/lukas/T9/Dobrovolny/17_12_24_bags/checker2/Images/0696.png");
% s = size(im);
% r = s(1);
% c = s(2);
% inliers = [];
% coords_3D = [];
% 
% for k = 1:length(pc.Location)
% 
%     [x, y] = cartesianToSpherical(pc.Location(k,1), pc.Location(k,2), pc.Location(k,3));
%     [z_x, z_y] = getPixelPosition(x,y,a_x,a_y);
%     p_x = ceil(z_x/a_0 - a_1);
%     p_y = ceil(z_y/A_0 - A_1);
% 
%     if p_x < c && p_y < r && p_x > 0 && p_y > 0
%         red = im(p_y, p_x,1);
%         green = im(p_y, p_x,2);
%         blue = im(p_y, p_x,3);
% 
%         pc.Color(k,:) = [red green blue];
% 
%         inliers(end+1,:) = [p_x, p_y];
%         coords_3D(end+1,:) = [pc.Location(k,1), pc.Location(k,2), pc.Location(k,3)];
%     else
%         pc.Color(k,:) = [255 255 255];
%         %pc.Location(i,:) = [];
%     end
% 
% end
% 
% % cloud = pointCloud(coords_3D);
% % pcshow(cloud);
% pcshow(pc);
% hold off;


%% Percision of the fusion - projecting point cloud plane into the image

imagePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/sphere5/simulator/chckerboard/data_for_calibration/images/');
imds = imageDatastore(imagePath);
imageFileNames = imds.Files;
ptCloudFilePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/sphere5/simulator/chckerboard/data_for_calibration/clouds/');
pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
pcFileNames = pcds.Files;
% load('camera_params_RGB_12_14_24.mat');
% load('/home/lukas/ros2_humble/camera_calib_intrinsics/gazebo_camera_params.mat');

maxDistance = 0.01;
numIter = 150;
x_max = -0.7;
x_min = -2;
y_min = -1.5;
y_max = 1.5;
z_min = -1;
z_max = 1;

for i = 1:length(pcFileNames)
    im = imread(imageFileNames{i});
    pc = pcread(pcFileNames{i});
    s = size(im);
    r = s(1);
    c = s(2);
    
    % Plane detection
    
    [groundPtsIdx, nonGroundCloud, groundCloud] = segmentGroundSMRF(pc, 'MaxWindowRadius', 1, 'SlopeThreshold', 0.5, 'ElevationThreshold', 0.6);
    cloudOut = nonGroundCloud;  % Not using plane detection
    %cloudOut = planeDetection(nonGroundCloud, maxDistance,numIter ,x_min, x_max, y_min, y_max, z_min, z_max);
        
    % pcshow(cloudOut);
    % im = undistortImage(im,params);
    imshow(im); hold on;
    for k = 1:length(cloudOut.Location)
    
        [x, y] = cartesianToSpherical(cloudOut.Location(k,1), cloudOut.Location(k,2), cloudOut.Location(k,3));
        [z_x, z_y] = getPixelPosition(x,y,a_x,a_y);
        p_x = ceil(z_x/a_0 - a_1);
        p_y = ceil(z_y/A_0 - A_1);
    
        if p_x < c && p_y < r && p_x > 0 && p_y > 0
            plot(p_x, p_y, 'r+'); hold on;
        end
        
    end
    close all;
end
% x_max = -0.5;
% x_min = -2;
% y_min = -1.6;
% y_max = 1.2;
% z_min = -0.2;
% z_max = 1;