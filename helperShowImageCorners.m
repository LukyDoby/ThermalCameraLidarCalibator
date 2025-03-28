function [imCorners2d,J] = helperShowImageCorners(imCorners3d, im, intrinsic)
    % helperShowImageCorners Function to display checkerboard corners
    %
    % This is an example helper function that is subject to change or removal in
    % future releases.
    
    % Copyright 2019 The MathWorks, Inc.
    % 
    % figureH = figure('Position', [0, 0, 480, 320]);
    % panel = uipanel('Parent', figureH, 'Position', [0 0 1 1], 'Title', 'Image Features');
    % ax = axes('Parent',panel);
    
    % Undistort image
    J = undistortImage(im, intrinsic);
    imCorners2d = projectLidarPointsOnImage(imCorners3d, intrinsic, rigid3d());
    % edge = [imCorners2d(4, 1:2); imCorners2d(1, 1:2)];
    % imshow(J, 'Parent', ax);
    % hold on;
    % draw detected edges on images
    % plot(imCorners2d(1:2, 1), imCorners2d(1:2, 2), '-', 'Color',...
    %     'green', 'LineWidth' ,4, 'Parent' ,ax);
    % plot(imCorners2d(2:3, 1), imCorners2d(2:3, 2), '-', 'Color',...
    %     'blue', 'LineWidth', 4, 'Parent', ax);
    % plot(imCorners2d(3:4, 1), imCorners2d(3:4, 2), '-', 'Color',...
    %     'magenta', 'LineWidth', 4,'Parent', ax);
    % plot(edge(:, 1), edge(:, 2), '-', 'Color',...
    %     'red', 'LineWidth', 4, 'Parent', ax);
    % draw corners in images
    % plot(imCorners2d(1, 1), imCorners2d(1, 2), 'og', 'MarkerSize', 10, 'Parent', ax);
    % plot(imCorners2d(2, 1), imCorners2d(2, 2), 'or', 'MarkerSize', 10, 'Parent', ax);
    % plot(imCorners2d(3, 1), imCorners2d(3, 2), 'ob', 'MarkerSize', 10, 'Parent', ax);
    % plot(imCorners2d(4, 1), imCorners2d(4, 2), 'om', 'MarkerSize', 10, 'Parent', ax);
    
end