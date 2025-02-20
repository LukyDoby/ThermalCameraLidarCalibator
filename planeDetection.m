function [cloudOut, finalCoeffs,bestPlanePoints] = planeDetection(cloud, maxDistance,numIter ,x_min, x_max, y_min, y_max, z_min, z_max)

    [~,nonGroundPtCloud,~] = segmentGroundSMRF(cloud,'ElevationThreshold', 0.1);
    points = nonGroundPtCloud.Location;
    points(points(:,1) < x_min, :) = [];
    points(points(:,1) > x_max, :) = [];
    points(points(:,2) < y_min, :) = [];
    points(points(:,2) > y_max, :) = [];
    points(points(:,3) < z_min, :) = [];
    points(points(:,3) > z_max, :) = [];
    cloud = pointCloud(points);
    gridStep = 0.02;
    ptCloudA = pcdownsample(cloud,'gridAverage',gridStep);
    % pcshow(ptCloudA);

    [bestPlanePoints,inliersFinal,finalCoeffs] = RANSAC_plane_fnc(ptCloudA.Location,numIter,maxDistance);
    inliersCloud = pointCloud(inliersFinal);
    [labels,numClusters] = pcsegdist(inliersCloud,0.04);

    idxValidPoints = find(labels);
    labelColorIndex = labels(idxValidPoints);
    segmentedPtCloud = select(inliersCloud,idxValidPoints);
    % figure
    % colormap(hsv(numClusters))
    % pcshow(segmentedPtCloud.Location,labelColorIndex)
    % title('Point Cloud Clusters')
    inliersFinal = segmentedPtCloud.Location;

    maxNumOfLabels = 0;
    clustersFinal = 0;
    for i = 1:numClusters
        idx = find(labels == i);
        numLabels = length(idx);
        if numLabels > maxNumOfLabels
            maxNumOfLabels = numLabels;
            clustersFinal = i;
        end
    end
    inliersFinal = inliersFinal(find(labels == clustersFinal), :);
    cloudOut = pointCloud(inliersFinal);
    % pcshow(cloudOut);

    %[model1,inlierIndices,outlierIndices] = pcfitplane(nonGroundPtCloud,maxDistance,referenceVector,maxAngularDistance);

    
    
end