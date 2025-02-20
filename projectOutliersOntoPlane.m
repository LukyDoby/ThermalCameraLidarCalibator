function cloudOut = projectOutliersOntoPlane(cloud, coeffs, planePoints,thresh)
    A = coeffs(1);
    B = coeffs(2);
    C = coeffs(3);
    D = coeffs(4);

    N =[A, B, C]; % normal vector
    N_norm = N / norm(N);  % Normalize normal vector

    a = 1;
    b = length(planePoints);
    r = round((b-a).*rand + a);

    P0 = planePoints(r,:); % random point on the plane
    proj_points = [];
    for i = 1:length(cloud.Location)
        P = cloud.Location(i,:);
        dist = abs(A * P(:,1) + B * P(:,2) + C * P(:,3) + D) / sqrt(A^2 + B^2 + C^2);
        if dist <= thresh

            proj_points(end+1,:) = P - ((P - P0) * N_norm') * N_norm;

        end
        
    end
    cloudOut = pointCloud(proj_points);

end