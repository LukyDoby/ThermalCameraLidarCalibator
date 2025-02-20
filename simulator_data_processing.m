%% Processing data from simulator
clear; clc; close all;
path = "/media/lukas/T9/Dobrovolny/17_12_24_bags/sphere4/simulator_undistorted";
numOfIter = 70;
thresh = 0.02;
ptImCentersCell = cell(25,3);

for i = 1:25
    %% read bag
    bag = ros2bagreader(strcat(path, '/position', num2str(i), "/position", num2str(i), "_0.db3"));
    imageBag = select(bag,'Topic','/camera/image_raw');
    pcBag = select(bag,'Topic','/pc2');

    %% Read all the messages    

    imageMsgs = readMessages(imageBag);
    pcMsgs = readMessages(pcBag);

    %% Data sync

    timeStampsIm = datetime(imageBag.MessageList.Time, 'ConvertFrom', 'posixtime', 'Format', 'dd-MMM-yyyy HH:mm:ss.SSS');
    timeStampsPc = datetime(pcBag.MessageList.Time, 'ConvertFrom', 'posixtime', 'Format', 'dd-MMM-yyyy HH:mm:ss.SSS');
    idx = [];
    k = 1;
    if size(timeStampsPc,1) > size(timeStampsIm,1)
        for n = 1:size(timeStampsIm,1)
            [val,indx] = min(abs(timeStampsIm(n) - timeStampsPc));
            if seconds(val) <= 0.05
                idx(k,:) = [n indx];
                k = k + 1;
            end
        end
    else
        for n = 1:size(timeStampsPc,1)
            [val,indx] = min(abs(timeStampsPc(n) - timeStampsIm));
            if seconds(val) <= 0.05
                idx(k,:) = [indx n];
                k = k + 1;
            end
        end
    end

    I = rosReadImage(imageMsgs{idx(1,1)});
    pc = pointCloud(rosReadXYZ(pcMsgs{idx(1,2)}));

    %% point cloud segmentation

    % pcshowpair(groundPtCloud,nonGroundPtCloud)
    % pcshow(nonGroundPtCloud);
    % close all;

    %% Select random clouds for center detection

    p = 4; % Number of unique numbers
    limit = length(idx); % Maximum limit (inclusive)
    rand_idx = randperm(limit, p);
    centers = [];
    radiis = [];

    for n = 1:p

        value = rand_idx(n);
        pc = pointCloud(rosReadXYZ(pcMsgs{idx(value,2)}));
        [~,nonGroundPtCloud,groundPtCloud] = segmentGroundSMRF(pc,MaxWindowRadius=5,ElevationThreshold=1.5,ElevationScale=0.4);

        %% Filter pc locations with -inf or inf

        pc_loc = nonGroundPtCloud.Location;
        validIndices = ~isinf(pc_loc(:,1)) & ~isinf(pc_loc(:,2)) & ~isinf(pc_loc(:,3));
        filteredPointCloud = pc_loc(validIndices, :);

        %% Ransac computing
        [bestSpherePoints,inliers] = RANSAC_sphere_fnc(filteredPointCloud,numOfIter,thresh);       %% STOP HERE
        accurancy = length(inliers)/length(filteredPointCloud);
        while accurancy < 0.97

            [bestSpherePoints,inliers] = RANSAC_sphere_fnc(filteredPointCloud,numOfIter,thresh);       %% STOP HERE
            accurancy = length(inliers)/length(filteredPointCloud);
        end
        pc = pointCloud(filteredPointCloud);
        [center,radius] = getTheEquationOfSphere(bestSpherePoints);

        %% Sphere plot with ptCloud

        % plot3(pc.Location(:,1),pc.Location(:,2),pc.Location(:,3), "b."); axis equal; hold on;
        % [X,Y,Z] = sphere;
        % r = radius;
        % X2 = X * r;
        % Y2 = Y * r;
        % Z2 = Z * r;
        % surf(X2+center(1),Y2 + center(2),Z2 + center(3))
        % hold off
        % close all;
        % 
        centers(end+1,:) = center;
        radiis(end+1,:) = radius;

    end
        ptImCentersCell{i,1} = median(centers);
        ptImCentersCell{i,2} = median(radiis);

        %% Detect center of a ball in image

        BW = greenMask(I);
        s = regionprops(BW,'centroid');
        centroids = cat(1,s.Centroid);
        % imshow(I); hold on;
        % plot(centroids(:,1),centroids(:,2),'b*')

        ptImCentersCell{i,3} = centroids;

end

