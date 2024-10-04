function [points] = project3DPointsOntoPlane(pointsNoise, normal, pointsOfPlane)

normal = normal(1:3);
points = [];
P0 = pointsOfPlane(1,:);

    for i = 1:length(pointsNoise)

        P1 = pointsNoise(i,:);
        % calculate vector v
        v = P1 - P0;
        % Calculate distance (d) from P1 to the plane along the normal vector
        d = dot(v, normal) / dot(normal, normal);
        % Calculate the projection of P1 onto the plane
        P_proj = P1 - d * normal;
        points(end+1,:) = P_proj;

    end

end
