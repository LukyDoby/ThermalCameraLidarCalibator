function [distance] = getTheDistanceOfPointFromLine(P1,P2,P3)
    
     lineVec = P2 - P1;
    
    % Vector from P1 to P3
    pointVec = P3 - P1;
    
    % Cross product of the two vectors
    crossProd = cross(pointVec, lineVec);
    
    % Magnitude of the cross product
    crossProdMag = norm(crossProd);
    
    % Magnitude of the line vector
    lineVecMag = norm(lineVec);
    
    % Distance from point P3 to the line
    distance = crossProdMag / lineVecMag;
    
end