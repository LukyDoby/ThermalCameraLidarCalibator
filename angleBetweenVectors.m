function theta_deg = angleBetweenVectors(u,v)

    dotProduct = dot(u, v);

    % Calculate the magnitude (norm) of u and v
    norm_u = norm(u);
    norm_v = norm(v);
    
    % Calculate the cosine of the angle
    cosTheta = dotProduct / (norm_u * norm_v);
    
    % Calculate the angle in radians
    theta = acos(cosTheta);
    
    % Convert the angle to degrees (optional)
    theta_deg = rad2deg(theta);

    
end