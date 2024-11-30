function corners = findCorners(boundary)
    % Input:
    %   boundary - Nx2 array of boundary points (x, y coordinates)
    % Output:
    %   corners - 4x2 array of corner points (x, y coordinates)
    
    % Ensure boundary is in a clockwise or counterclockwise order
    boundary = unique(boundary, 'rows', 'stable');
    
    % Number of points
    n = size(boundary, 1);
    
    % Preallocate array for angles
    angles = zeros(n, 1);
    
    % Loop through each point in the boundary
    for i = 1:n
        % Get the previous, current, and next points
        prev_idx = mod(i-2, n) + 1; % Previous point index (circular indexing)
        next_idx = mod(i, n) + 1;   % Next point index (circular indexing)
        
        prev_point = boundary(prev_idx, :);
        curr_point = boundary(i, :);
        next_point = boundary(next_idx, :);
        
        % Compute vectors
        v1 = prev_point - curr_point; % Vector from previous to current
        v2 = next_point - curr_point; % Vector from current to next
        
        % Normalize vectors
        v1 = v1 / norm(v1);
        v2 = v2 / norm(v2);
        
        % Compute the angle using the dot product
        angle = acos(dot(v1, v2));
        
        % Store the angle in radians
        angles(i) = angle;
    end
    
    % Find the 4 smallest angles (corners)
    [~, corner_indices] = mink(angles, 4);
    
    % Extract the corner points
    corners = boundary(corner_indices, :);
end
