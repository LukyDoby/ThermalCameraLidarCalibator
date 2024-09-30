function [first_line_pts,second_line_pts,third_line_pts,fourth_line_pts] = SplitbBoundariesInto4Lines(left_boundaires,right_boundaires)
    
    angles_left = [];
    angles_right = [];
    for i = 2:length(right_boundaires)-1
    
        left_P = left_boundaires(i-1,:);
        left_Q = left_boundaires(i,:);
        left_R = left_boundaires(i+1,:);
    
        right_P = right_boundaires(i-1,:);
        right_Q = right_boundaires(i,:);
        right_R = right_boundaires(i+1,:);
    
        u_left = left_P-left_Q;
        v_left = left_R-left_Q;
    
        u_right = right_P-right_Q;
        v_right = right_R-right_Q;
    
        theta_deg_left = angleBetweenVectors(u_left,v_left);
    
        theta_deg_right = angleBetweenVectors(u_right,v_right);
    
        angles_left(end+1) = theta_deg_left;
        angles_right(end+1) = theta_deg_right;
    
    end
    idx_of_largest_change_left = find(angles_left==min(angles_left)); % largest change coresponds to a minimal angle
    idx_of_largest_change_right = find(angles_right==min(angles_right));
    
    first_line_pts = left_boundaires(1:idx_of_largest_change_left,:);
    second_line_pts = left_boundaires(idx_of_largest_change_left+1:end,:);
    third_line_pts = right_boundaires(1:idx_of_largest_change_right,:);
    fourth_line_pts = right_boundaires(idx_of_largest_change_right+1:end,:);

end