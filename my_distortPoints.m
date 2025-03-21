function distorted_points = my_distortPoints(undistorted_points, cameraParams)
    % Extract intrinsic parameters
    K = cameraParams.IntrinsicMatrix'; % Transpose because MATLAB stores as column-major
    k1 = cameraParams.RadialDistortion(1);
    k2 = cameraParams.RadialDistortion(2);
    k3 = cameraParams.RadialDistortion(3);
    p1 = cameraParams.TangentialDistortion(1);
    p2 = cameraParams.TangentialDistortion(2);

    % Convert undistorted pixel points to normalized coordinates
    uv = undistorted_points; % [Nx2] matrix of (u, v)
    x_norm = (uv(:,1) - K(1,3)) / K(1,1);
    y_norm = (uv(:,2) - K(2,3)) / K(2,2);

    % Compute radius squared
    r2 = x_norm.^2 + y_norm.^2;

    % Compute radial distortion
    radial_factor = 1 + k1 * r2 + k2 * r2.^2 + k3 * r2.^3;
    
    % Compute tangential distortion
    x_tangential = 2 * p1 * x_norm .* y_norm + p2 * (r2 + 2 * x_norm.^2);
    y_tangential = p1 * (r2 + 2 * y_norm.^2) + 2 * p2 * x_norm .* y_norm;

    % Apply distortion
    x_distorted = x_norm .* radial_factor + x_tangential;
    y_distorted = y_norm .* radial_factor + y_tangential;

    % Convert back to pixel coordinates
    u_distorted = x_distorted * K(1,1) + K(1,3);
    v_distorted = y_distorted * K(2,2) + K(2,3);
    
    distorted_points = [u_distorted, v_distorted];
end
