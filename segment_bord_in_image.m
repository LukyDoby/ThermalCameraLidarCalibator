%% Segment calibration board in image
clear; clc; close all

%% Load images and point cloud data into the workspace.

imagePath = fullfile('/media/lukas/T9/Dobrovolny/17_12_24_bags/chacker1/data_for_calibration/images/');
imds = imageDatastore(imagePath);
imageFileNames = imds.Files;

%% Line segment detector

%% Detect checkerboard

x_off = 300;
y_off = 200;
w = 800;
h = 700;
pyrun(['import cv2']);
pyrun(['lsd = cv2.createLineSegmentDetector(refine=cv2.LSD_REFINE_ADV,scale=0.8,sigma_scale=0.8,quant=2.0,ang_th=22.5,log_eps=0.0,density_th=0.8, n_bins=1024)']);

for i = 7:length(imageFileNames)

    im = imread(imageFileNames{i});
    [imagePoints,boardSize] = detectCheckerboardPoints(im);
    lowest_y_coord_idx = find(imagePoints(:,2) == (min(imagePoints(:,2))));
    
    %% make ROI based on checkerboard location
    s = size(im);
  
    if(imagePoints(lowest_y_coord_idx,1) - x_off) <= 1
        x_off = imagePoints(1,1) - 1;
    end
    
    if(imagePoints(lowest_y_coord_idx,2) - y_off) <= 1
        y_off = imagePoints(1,2) - 1;
    end
    
    if(x_off + w) > s(2)
        w = s(2) - x_off;
    end
    
    if(y_off + h) > s(1)
        h = s(1) - y_off;
    end
    
    rect = [imagePoints(lowest_y_coord_idx,1) - x_off, imagePoints(lowest_y_coord_idx,2) - y_off, w,h];
    im_cropped = imcrop(im, rect);
    
    % imshow(im);
    % hold on;
    % rectangle('Position',rect,'EdgeColor','r');
    % close all;

    % pyrun(['import cv2']);
    pyrun(['im = cv2.imread(im,0)'], im = imageFileNames{i});
    %pyrun(['im = cv2.imread(im_cropped),0)']);
    %pyrun(['lsd = cv2.createLineSegmentDetector()']);
    % pyrun(['lsd = cv2.createLineSegmentDetector(refine=cv2.LSD_REFINE_ADV,scale=0.8,sigma_scale=0.6,quant=2.0,ang_th=22.5,log_eps=0.0,density_th=0.6, n_bins=1024)']);
    l = pyrun(['lines = lsd.detect(im)[0]'],"lines");
    coords = single(l);

    % imshow(im); hold on;

    x1 = coords(:,:,1);
    y1 = coords(:,:,2);
    x2 = coords(:,:,3);
    y2 = coords(:,:,4);

    % imshow(im); hold on;
    % for k = 1:length(coords)
    %     plot([x1(k), x2(k)], [y1(k), y2(k)], 'LineWidth', 2); hold on;
    % %     Plot the line
    % end

    detectDeskCorners(im, coords, imagePoints,boardSize);
    % 
    % imshow(im); hold on;
    % for k = 1:length(coords)
    %     plot([x1(k), x2(k)], [y1(k), y2(k)], 'LineWidth', 2); hold on;
    %     % Plot the line
    % end

    close all;

end
