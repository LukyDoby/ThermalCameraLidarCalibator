function [bestPlanePoints,inliersFinal,finalPlaneCoeffs] = RANSAC_plane_fnc(planePoints,numOfIter,thresh)
    
numsOfInliers = 0;
bestPlanePoints = [];
finalPlaneCoeffs = [];
inliersFinal = [];
numOfPtsNeeded = 3;
idxToRemove = [];
for i = 1:length(planePoints)
    if any(planePoints(i,:) == inf)
        idxToRemove(end+1,:) = i;
    end
end
planePoints(idxToRemove,:) = [];

for n = 1:numOfIter
    %% pick 3 random points
    
    % a = 1; % lower bound
    % b = length(planePoints); % upper bound
    % i = 1;
    % while i <=numOfPtsNeeded
    % 
    %     randomNumber = round(a + (b-a) * rand);
    %     if ~any(ismember(planePoints(randomNumber,:), randPoints) == 1)
    %         randPoints(end+1,:) = planePoints(randomNumber,:);
    %         i = i+1;
    %     end
    % 
    % end

    limit = length(planePoints); % Maximum limit (inclusive)
    rand_idx = randperm(limit, numOfPtsNeeded);
    randPoints = planePoints(rand_idx,:);

    while(any(isinf(randPoints)))

        rand_idx = randperm(limit, p);
        randPoints = planePoints(rand_idx,:);
    end
    
    
    
    %% compute the plane equation
    cf = getTheEquationOfPlane(randPoints);
    
    %% calculate the deviation of all points from the plane
  
    inliers = [];
    for k = 1:length(planePoints)
        point = planePoints(k,:);
        dist = (abs(cf(1)*point(1) + cf(2)*point(2) + cf(3)*point(3) + cf(4)))/sqrt(cf(1)^2 + cf(2)^2 + cf(3)^2);
        if abs(dist) <= thresh
            inliers(end+1,:) = point;
        end
    
    end

   if numsOfInliers < length(inliers)
        bestPlanePoints = randPoints;
        inliersFinal = inliers;
        finalPlaneCoeffs = cf;
        numsOfInliers = length(inliers);

    end
    

end

end