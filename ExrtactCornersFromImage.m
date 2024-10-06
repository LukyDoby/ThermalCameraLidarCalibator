function cornersFinal = ExrtactCornersFromImage(imagePoints, boardSize,im)

%% extract corner points but not really wanted corners
    corners(1,:) = imagePoints(1,:);
    corners(2,:) = imagePoints(boardSize(1)-1, :);
    corners(3,:) = imagePoints( ((boardSize(1)-1)*(boardSize(2)-1)) - (boardSize(1)-2),:);
    corners(4,:) = imagePoints((boardSize(1)-1)*(boardSize(2)-1),:); 

 %% vectors and distances

 v1_2 = corners(1,:) - corners(2,:);
 v1_3 = corners(1,:) - corners(3,:);
 v2_4 = corners(2,:) - corners(4,:);
 v3_4 = corners(3,:) - corners(4,:);

 dist1_2 = norm(v1_2); %distances of detected corners
 dist1_3 = norm(v1_3);
 dist2_4 = norm(v2_4);
 dist3_4 = norm(v3_4);

 %% Lengths of checkerboard squres in every boundary lines

 l1_2 = dist1_2/(boardSize(1)-2);
 l1_3 = dist1_3/(boardSize(2)-2);
 l2_4 = dist2_4/(boardSize(2)-2);
 l3_4 = dist3_4/(boardSize(1)-2);

 %% estimate real corners of a checkerboard
 est_corn_1 = corners(1,:) + l1_2/norm(v1_2) *v1_2 + l1_3/norm(v1_3) * v1_3;
 est_corn_2 = corners(2,:) + l2_4/norm(v2_4) *v2_4 + l1_2/norm(v1_2) * (-v1_2);
 est_corn_3 = corners(3,:) + l3_4/norm(v3_4) *v3_4 + l1_3/norm(v1_3) * (-v1_3);
 est_corn_4 = corners(4,:) + l2_4/norm(v2_4) *(-v2_4) + l1_3/norm(v3_4) * (-v3_4);

 % imshow(im); hold on; plot(est_corn_1(1), est_corn_1(2), 'r+');
 % hold on;  plot(est_corn_2(1), est_corn_2(2),'r+');
 % hold on;  plot(est_corn_3(1), est_corn_3(2),'r+');
 %hold on;  plot(est_corn_4(1), est_corn_4(2),'r+');

 %% Make ROI around every point and detect straight lines

 ROI_1 = imcrop(im, [est_corn_1(1)-10, est_corn_1(2)-10, 20, 20]);
 ROI_2 = imcrop(im, [est_corn_2(1)-10, est_corn_2(2)-10, 20, 20]);
 ROI_3 = imcrop(im, [est_corn_3(1)-10, est_corn_3(2)-10, 20, 20]);
 ROI_4 = imcrop(im, [est_corn_4(1)-10, est_corn_4(2)-10, 20, 20]);

 % bw1 = edge(im2gray(ROI_1),'canny');
 % bw2 = edge(im2gray(ROI_2),'canny');
 % bw3 = edge(im2gray(ROI_3),'canny');
 % bw4 = edge(im2gray(ROI_4),'canny');

%% Harris corner detector
corner1 = detectHarrisFeatures(im2gray(ROI_1));
corner1 = corner1.selectStrongest(1);
corner1 = [corner1.Location(1) + est_corn_1(1) - 11, corner1.Location(2) + est_corn_1(2) - 11];


corner2 = detectHarrisFeatures(im2gray(ROI_2));
corner2 = corner2.selectStrongest(1);
corner2 = [corner2.Location(1) + est_corn_2(1) - 11, corner2.Location(2) + est_corn_2(2) - 11];

corner3 = detectHarrisFeatures(im2gray(ROI_3));
corner3 = corner3.selectStrongest(1);
corner3 = [corner3.Location(1) + est_corn_3(1) - 11, corner3.Location(2) + est_corn_3(2) - 11];

corner4 = detectHarrisFeatures(im2gray(ROI_4));
corner4 = corner4.selectStrongest(1);
corner4 = [corner4.Location(1) + est_corn_4(1) - 11, corner4.Location(2) + est_corn_4(2) - 11];

%% Final corners

cornersFinal = [corner1; corner2; corner3; corner4];

end