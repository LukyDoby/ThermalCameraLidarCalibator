function [inliersFinal] = RANSAC_line_fnc(line_pts,numOfIter,thresh)

numsOfInliers = 0;
inliersFinal = [];

numOfPtsNeeded = 2;

for n = 1:numOfIter
    %% pick 2 random points
    randPoints= [];
    
    a = 1; % lower bound
    b = length(line_pts); % upper bound
    i = 1;
    while i <= numOfPtsNeeded
    
        randomNumber = round(a + (b-a) * rand);
        if ~any(ismember(line_pts(randomNumber,:), randPoints) == 1)
            randPoints(end+1,:) = line_pts(randomNumber,:);
            i = i+1;
        end
        
    end
    
    %% calculate the deviation of all points from the line
  
    inliers = [];
        for k = 1:length(line_pts)
            point = line_pts(k,:);
            dist = getTheDistanceOfPointFromLine(randPoints(1,:),randPoints(:,2),point);

            if abs(dist) <= thresh
                inliers(end+1,:) = point;
            end
      
        end

    if numsOfInliers < length(inliers)
        inliersFinal = inliers;
        numsOfInliers = length(inliers);
    end
end
    
end