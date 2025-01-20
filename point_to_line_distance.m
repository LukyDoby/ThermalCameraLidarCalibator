function d = point_to_line_distance(x0, y0, x1, y1, x2, y2)
    % Numerator of the distance formula
    numerator = abs((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1);
    
    % Denominator of the distance formula
    denominator = sqrt((y2 - y1)^2 + (x2 - x1)^2);
    
    % Distance computation
    d = numerator / denominator;
end
