%% Refine center detection
clear; clc; close all;

numOfIter = 30;
thresh = 0.02;
ptImCentersCell = cell(25,3);     % 1. col are medians of ptCloud centers, 2. col are medians of ptCloud radiis, 3. col are image centers
%load("im_ptCl_centers_refine_8_9_24.mat");
for i = 1:25
    
    %% extract point clouds

    folderPath = strcat(num2str(i), "\PointClouds");
    fileList = dir(folderPath);
    fileList = fileList(~ismember({fileList.name}, {'.', '..'}));
    numFiles = sum(~[fileList.isdir]);
    if numFiles>0
        centers = [];
        radiis = [];

        %% random vector for iteration
        a = 1;
        max_ptClouds;
        random_vector = randperm(numFiles-a+1, max_ptClouds) + (a-1);
        for n = 1:length(random_vector)
            value = random_vector(n);
            fileListCell = struct2cell(fileList);
            pcName = fileListCell{1,value};
            pc = pcread(strcat(fileListCell{2,value},"\",pcName));
            pcshow(pc);
         
            [bestSpherePoints,inliers] = RANSAC_sphere_fnc(brushedData,numOfIter,thresh);       %% STOP HERE
            accurancy = length(inliers)/length(brushedData);
            while accurancy < 0.8

                [bestSpherePoints,inliers] = RANSAC_sphere_fnc(brushedData,numOfIter,thresh);       %% STOP HERE
                accurancy = length(inliers)/length(brushedData);
            end
     
            [center,radius] = getTheEquationOfSphere(bestSpherePoints);

            % Sphere plot with ptCloud

            plot3(pc.Location(:,1),pc.Location(:,2),pc.Location(:,3), "b."); axis equal; hold on;
            [X,Y,Z] = sphere;
            r = radius;
            X2 = X * r;
            Y2 = Y * r;
            Z2 = Z * r;
            surf(X2+center(1),Y2 + center(2),Z2 + center(3))
            hold off
        
            centers(end+1,:) = center;
            radiis(end+1,:) = radius;
            clear brushedData;

        end
        ptImCentersCell{i,1} = median(centers);
        ptImCentersCell{i,2} = median(radiis);

    end

    %% calculate centers of images

    folderPath = strcat(num2str(i), "\Images");
    fileList = dir(folderPath);
    fileList = fileList(~ismember({fileList.name}, {'.', '..'}));
    numImFiles = sum(~[fileList.isdir]);

    if(numImFiles>0)
        im = imread(strcat(fileList.folder,"\", fileList.name));
        BW = greenMask(im);
        s = regionprops(BW,'centroid');
        centroids = cat(1,s.Centroid);
    
        imshow(im); hold on; 
        plot(centroids(:,1),centroids(:,2),'b*')
        hold off
    
        ptImCentersCell{i,3} = centroids;
    end


end