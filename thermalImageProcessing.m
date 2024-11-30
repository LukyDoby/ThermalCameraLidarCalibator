function [corners, im_undist] = thermalImageProcessing(img,thresh, intrinsic)

    s = size(img);
    im_undist = undistortImage(img, intrinsic);
    bw = im_undist > thresh;
    im_cropped = imcrop(bw, [1, 1, s(2)-5, s(1)-5]);
    bw = imclearborder(im_cropped);
    im_opened = bwareaopen(bw, 20);
    points = detectHarrisFeatures(im_opened);
    x = points.Location(:,1);
    y = points.Location(:,2);
    j = boundary(double(x),double(y),0.1);
    % plot(x(j),y(j), 'LineWidth', 2);
    boundaries = [double(x(j)),double(y(j))];
    corners = findCorners(boundaries);
    % imshow(im_undist);hold on;
    % plot(corners(:,1), corners(:,2), 'r+');
    
end