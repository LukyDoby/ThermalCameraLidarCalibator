function corners3D = myEstimateThermal3DCorners(corners2D, boardSize, intrinsic)
    
    %worldPoints = generateWorldPoints(boardSize,square_size);
    worldPoints = [0 0 ;0 boardSize(1) ; boardSize(2) 0 ; boardSize(2) boardSize(1)];
    camExtrinsics = estimateExtrinsics(double(corners2D),worldPoints,intrinsic);

    %% Estimating extrinsics
    R = camExtrinsics.R;
    t = camExtrinsics.Translation;
    t = t';
    K = intrinsic.K;

    %% Compute the plane equation from image

    % Normal vector in world coordinates (XY-plane normal)
    normal_world = [0; 0; 1];
    
    % Compute normal vector in camera coordinates (apply rotation)
    n_camera = R * normal_world;
    
    % Compute plane offset in camera coordinates (distance from camera to plane)
    d_camera = dot(n_camera, t);  % t is the translation from world to camera

    %% Compute ray plane intnersection
    corners3D = [];

    for i = 1: length(corners2D)

        imgPoint = [corners2D(i,:)'; 1];
        ray_dir = inv(K)* imgPoint;
        ray_dir = ray_dir / norm(ray_dir);    
        lambda = d_camera / dot(n_camera, ray_dir);
        X_intersect =lambda * ray_dir;
        X_intersect = X_intersect ./ 1000; % from millimeters to meters
       % X_intersect = transformPointsToCloudCoordinates(X_intersect);
        corners3D(end+1,:) = X_intersect';
    end

end
