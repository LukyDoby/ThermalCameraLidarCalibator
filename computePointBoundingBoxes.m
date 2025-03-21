function bboxes = computePointBoundingBoxes(points, imageSize, boxSize)

    if isscalar(boxSize)
        boxWidth = boxSize;
        boxHeight = boxSize;
    else
        boxWidth = boxSize(2);
        boxHeight = boxSize(1);
    end

    halfWidth = floor(boxWidth / 2);
    halfHeight = floor(boxHeight / 2);

    numPoints = size(points, 1);
    bboxes = zeros(numPoints, 4);

    for i = 1:numPoints
        % Centered box
        xMin = points(i, 1) - halfWidth;
        yMin = points(i, 2) - halfHeight;

        % Clip to image boundaries
        xMin = max(1, xMin);
        yMin = max(1, yMin);

        xMax = min(imageSize(2), xMin + boxWidth - 1);
        yMax = min(imageSize(1), yMin + boxHeight - 1);

        % Adjust width and height to handle edge clipping
        width = xMax - xMin + 1;
        height = yMax - yMin + 1;

        % Store the bounding box for this point
        bboxes(i, :) = [xMin, yMin, width, height];
    end
end
