function [bestSpherePoints,inliersFinal] = RANSAC_sphere_fnc(spherePoints,numOfIter,thresh)
    
numsOfInliers = 0;
bestSpherePoints = [];
inliersFinal = [];
numOfPtsNeeded = 4;

%% Filtering inf points

% idxToRemove = [];
% for i = 1:length(spherePoints)
%     if any(spherePoints(i,:) == inf)
%         idxToRemove(end+1,:) = i;
%     end
% end
% spherePoints(idxToRemove,:) = [];


for n = 1:numOfIter
    %% pick 4 random points
    % 
    % a = 1; % lower bound
    % b = length(spherePoints); % upper bound
    % i = 1;
    % while i <=4
    % 
    %     randomNumber = round(a + (b-a) * rand);
    %     if ~any(ismember(spherePoints(randomNumber,:), randPoints) == 1)
    %         randPoints(i,:) = spherePoints(randomNumber,:);
    %         i = i+1;
    %     end
    % 
    % end
    limit = length(spherePoints); % Maximum limit (inclusive)
    rand_idx = randperm(limit, numOfPtsNeeded);
    randPoints = spherePoints(rand_idx,:);
    
    %% compute the sphere equation
    [center,radius] = getTheEquationOfSphere(randPoints);
    
    %% calculate the deviation of all points from the sphere
  
    inliers = [];
    for k = 1:length(spherePoints)
        point = spherePoints(k,:);
        dist = sqrt((point(1) - center(1))^2 + (point(2) - center(2))^2 + (point(3) - center(3))^2) - radius;
        if abs(dist) <= thresh
            inliers(end+1,:) = point;
        end
    
    end
    
    if numsOfInliers < length(inliers)
        bestSpherePoints = randPoints;
        inliersFinal = inliers;
        numsOfInliers = length(inliers);
    end
    

end

end