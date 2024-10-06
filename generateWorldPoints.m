function worldPoints = generateWorldPoints(boardSize, squareSize)
    % generateWorldPoints generates the world coordinates of the checkerboard corners.
    %
    % boardSize  - Size of the board as [rows, cols], where rows is the number
    %              of squares along the height of the checkerboard and cols
    %              is the number of squares along the width.
    %
    % squareSize - The size of each square in the checkerboard, in the same units
    %              you want the world points to be generated in (e.g., millimeters, centimeters).
    %
    % worldPoints - Nx2 array of [X, Y] coordinates of the checkerboard corners
    %               where N is the total number of corners ((rows-1) * (cols-1)).

    % Calculate the number of inner corners (i.e., points)
    numRows = boardSize(1) - 1;
    numCols = boardSize(2) - 1;
    
    % Generate grid of points
    [X, Y] = meshgrid(0:numCols-1, 0:numRows-1);
    
    % Reshape the grid into a list of points and scale by the square size
    worldPoints = [X(:) Y(:)] * squareSize;
    %worldPoints(:,end+1) = zeros(numRows*numCols,1);
end