function [bestSpherePoints,inliersFinal] = RANSAC_sphere_fnc(spherePoints,numOfIter,thres)
    
numsOfInliers = 0;
bestSpherePoints = [];
inliersFinal = [];
for n = 1:numOfIter
    %% pick 4 random points
    randPoints= [];
    
    a = 1; % lower bound
    b = length(spherePoints); % upper bound
    i = 1;
    while i <=4
    
        randomNumber = round(a + (b-a) * rand);
        if ~any(ismember(spherePoints(randomNumber,:), randPoints) == 1)
            randPoints(i,:) = spherePoints(randomNumber,:);
            i = i+1;
        end
        
    end
    
    %% compute the sphere equation
    [center,radius] = getTheEquationOfSphere(randPoints);
    
    %% calculate the deviation of all points from the sphere
  
    inliers = [];
    for k = 1:length(spherePoints)
        point = spherePoints(k,:);
        dist = sqrt((point(1) - center(1))^2 + (point(2) - center(2))^2 + (point(3) - center(3))^2) - radius;
        if abs(dist) <= thres
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