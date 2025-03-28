function [percentage_project_pts,areas_ratio] = computeNumOfProjectedPts(im, points, image3Dcorners,intrinsic, distort_pts_bool)

    [imCorners2d,im_undist] = helperShowImageCorners(image3Dcorners, im, intrinsic);

    %% Divide points into LH, LD, PH, PD
    % 
    sorted_by_X = sortrows(imCorners2d,1);
    LH_LD = sorted_by_X(1:2,:);
    PH_PD = sorted_by_X(3:4,:);

    LH_LD_sorted_by_Y = sortrows(LH_LD,2);
    LH = LH_LD_sorted_by_Y(1,:);
    LD = LH_LD_sorted_by_Y(2,:);

    PH_PD_sorted_by_Y = sortrows(PH_PD,2);
    PH = PH_PD_sorted_by_Y(1,:);
    PD = PH_PD_sorted_by_Y(2,:);

    %% Distort points for spehre fusion
    if(distort_pts_bool)

        LH = distortPoints(intrinsic,LH);
        PH = distortPoints(intrinsic,PH);
        PD = distortPoints(intrinsic,PD);
        LD = distortPoints(intrinsic,LD);

    end

    %% Ploting result of points division 
    % imshow(im_undist); 
    % hold on
    % labels = {'LH', 'LD', 'PH', 'PD'};
    % im_corners_divided = [LH; LD; PH; PD];
    % 
    % for i = 1:length(im_corners_divided)
    % 
    %     plot(im_corners_divided(:,1),im_corners_divided(:,2), 'b+', 'MarkerSize',8);
    %     text(im_corners_divided(i, 1) + 10, im_corners_divided(i, 2), labels{i}, 'Color', 'yellow', 'FontSize', 12, 'FontWeight', 'bold');
    %     hold on
    % end

    %% Checking if points belong to recangle area

    rectangle_x = [LH(1), PH(1), PD(1), LD(1), LH(1)]; 
    rectangle_y = [LH(2), PH(2),PD(2), LD(2), LH(2)];
    
    inside = inpolygon(points(:,1), points(:,2), rectangle_x, rectangle_y);
    points_in = points(inside,:);
    points_out = points(~inside,:);

    %% calculate Hausdorff Distance for boundary matching

    % corners = [LH(1), LH(2); PH(1) PH(2); PD(1) PD(2); LD(1) LD(2)];
    % points_x = points(:,1);
    % points_y = points(:,2);
    % k = boundary(points_x,points_y);
    % hold on;
    % plot(points_x(k),points_y(k),'-y');
    % bound_pts = [points_x(k), points_y(k)];
    % distances = pdist2(corners, bound_pts, 'euclidean');
    % min_distances = min(distances, [], 1);
    % hausdorff_dist = max(min_distances);

    %% Calculate area of inside points

    points_x = points_in(:,1);
    points_y = points_in(:,2);
    k = boundary(points_x,points_y, 0.8);
    bound_pts = [points_x(k), points_y(k)];
    hold on;
    plot(bound_pts(:,1), bound_pts(:,2), 'y-');
    area_pts_in = polyarea(bound_pts(:,1), bound_pts(:,2));

    corners = [LH(1), LH(2); PH(1) PH(2); PD(1) PD(2); LD(1) LD(2)];
    area_corner_pts = polyarea(corners(:,1), corners(:,2));

    areas_ratio = area_pts_in/area_corner_pts;



   %% Plotting resuts
    if(distort_pts_bool)
        imshow(im);
    else
        imshow(im_undist);
    end
   
   hold on;
   plot([LH(1),PH(1)], [LH(2),PH(2)], "b-", 'LineWidth',1);
   plot([PH(1),PD(1)], [PH(2),PD(2)], "b-", 'LineWidth',1);
   plot([PD(1),LD(1)], [PD(2),LD(2)], "b-", 'LineWidth',1);
   plot([LD(1),LH(1)], [LD(2),LH(2)], "b-", 'LineWidth',1);
   plot(points_in(:,1), points_in(:,2), 'g+');
   plot(points_out(:,1), points_out(:,2), 'r+');

   %% Compute ratio of points inside and all points
    
   percentage_project_pts = length(points_in)/length(points);

end