function [left_boundaires, right_boundaires] = ExtractBounadryPtsOfCheckerFromCloud(inliers)

    scan_line_thresh = 0.03;
    scan_line_pts = [];
    left_boundaires = [];
    right_boundaires = [];
    for i = 1:length(inliers)-1
        
        if(abs(inliers(i,3)- inliers(i+1,3)) > scan_line_thresh) % exracting ray beams
            
            scan_line_pts(end+1,:) = inliers(i,:);
            scan_line_pts = sortrows(scan_line_pts,2);
            left_boundaires(end+1,:) = scan_line_pts(end,:);
            right_boundaires(end+1,:) = scan_line_pts(1,:);
            scan_line_pts = [];
        else
            scan_line_pts(end+1,:) = inliers(i,:);
    
        end
        
    end
    
            scan_line_pts(end+1,:) = inliers(end,:);
            scan_line_pts = sortrows(scan_line_pts,2);
            left_boundaires(end+1,:) = scan_line_pts(end,:);
            right_boundaires(end+1,:) = scan_line_pts(1,:);
end
