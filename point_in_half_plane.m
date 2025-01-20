function isInHalfPlane = point_in_half_plane(x0, y0, x1, y1, x2, y2, side)
    % Compute line equation coefficients
    a = y2 - y1;
    b = x1 - x2;
    c = x2 * y1 - x1 * y2;
    
    % Evaluate the line equation for the point
    f = a * x0 + b * y0 + c;
    
    % Check the half-plane condition
    if strcmpi(side, 'positive')
        isInHalfPlane = (f > 0);
    elseif strcmpi(side, 'negative')
        isInHalfPlane = (f < 0);
    else
        error('Invalid "side" parameter. Use "positive" or "negative".');
    end
end
