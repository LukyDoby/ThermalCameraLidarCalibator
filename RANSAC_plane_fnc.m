function [bestPlanePoints,inliersFinal,finalPlaneCoeffs] = RANSAC_plane_fnc(planePoints,numOfIter,thresh)
    
numsOfInliers = 0;
bestPlanePoints = [];
finalPlaneCoeffs = [];
inliersFinal = [];
numOfPtsNeeded = 3;

for n = 1:numOfIter
    %% pick 4 random points
    randPoints= [];
    
    a = 1; % lower bound
    b = length(planePoints); % upper bound
    i = 1;
    while i <=numOfPtsNeeded
    
        randomNumber = round(a + (b-a) * rand);
        if ~any(ismember(planePoints(randomNumber,:), randPoints) == 1)
            randPoints(end+1,:) = planePoints(randomNumber,:);
            i = i+1;
        end
        
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