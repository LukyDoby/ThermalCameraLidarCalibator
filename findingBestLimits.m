%% Finding best limits
clear; clc; close all;

cloudFile = dir(fullfile("/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker5/data_for_calibration/clouds/"));
cloudFileNames = {cloudFile.name};
cloudFile(ismember(cloudFileNames, {'.', '..'})) = [];
numOfDataPerOneShot = 1;
x_max = -0.7;
x_min = -3;
y_min = -1.5;
y_max = 1.4;
z_min =-0.8;
z_max = 1.8;

for i = 1:length(cloudFileNames)
            cloud = pcread(fullfile(cloudFile(i).folder,cloudFile(i).name));
           % [groundPtsIdx, nonGroundCloud, groundCloud] = segmentGroundSMRF(cloud, 'MaxWindowRadius', 0.5, 'SlopeThreshold', 0.5, 'ElevationThreshold', 0.05);
            points = cloud.Location;
            points(points(:,1) < x_min, :) = [];
            points(points(:,1) > x_max, :) = [];
            points(points(:,2) < y_min, :) = [];
            points(points(:,2) > y_max, :) = [];
            points(points(:,3) < z_min, :) = [];
            points(points(:,3) > z_max, :) = [];
            cloud = pointCloud(points);
            pcshow(cloud); 
            xlabel('x');ylabel('y');zlabel('z')
            close all;
end