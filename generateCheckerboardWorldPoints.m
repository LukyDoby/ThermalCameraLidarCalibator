function worldPoints = generateCheckerboardWorldPoints(squareSize, boardSize)

    % Number of corners along each dimension
    numCornersX = boardSize(2) - 1;
    numCornersY = boardSize(1) - 1;

    % Generate grid of corner points
    [x, y] = meshgrid(0:numCornersX-1, 0:numCornersY-1);

    % Scale by square size
    x = x * squareSize;
    y = y * squareSize;

    worldPoints = [x(:), y(:), zeros(numel(x), 1)];

end
