%% RANSAC plane
clearvars -except brushedData; clc; close all

cloud = pcread("checkerboard_09_25/data_for_calibration/clouds/0013.pcd");
%pcshow(cloud);

numOfIter = 3;
thresh = 0.02;

[bestPlanePoints,inliers,cf] = RANSAC_plane_fnc(brushedData,numOfIter,thresh);

%% Plotting results

% [x, y] = meshgrid(1:0.1:3, -1:0.1:1); 
% A = cf(1); B = cf(2); C =cf(3); D = cf(4);
% z = (-D -A*x -B*y)/C;

% pcshow(cloud);
% hold on;
% surf(x, y, z);

%% Extract bounadry points of checkerboard from cloud
[left_boundaires, right_boundaires] = ExtractBounadryPtsOfCheckerFromCloud(inliers);
        % pcshow(cloud);
        % hold on;
        % plot3(left_boundaires(:,1),left_boundaires(:,2),left_boundaires(:,3), "r+")
        % hold on
        % plot3(right_boundaires(:,1),right_boundaires(:,2),right_boundaires(:,3), "b+")

%% Split boundaries into 4 lines 
[first_line,second_line,third_line,fourth_line] = SplitbBoundariesInto4Lines(left_boundaires,right_boundaires);
pcshow(cloud);

hold on;
plot3(first_line(:,1),first_line(:,2),first_line(:,3), "r+")
hold on
plot3(second_line(:,1),second_line(:,2),second_line(:,3), "g+")
hold on
plot3(third_line(:,1),third_line(:,2),third_line(:,3), "c+")
hold on
plot3(fourth_line(:,1),fourth_line(:,2),fourth_line(:,3), "w+")


%% Find edge lines using RANSAC

