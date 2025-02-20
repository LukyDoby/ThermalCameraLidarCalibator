function points_in = myFuseCameraLidarSpehre(im,cloud,a_x,a_y,a_0,a_1,A_0, A_1)
    s = size(im);
    r = s(1);
    c = s(2);
    points_in = [];
 for k = 1:length(cloud.Location)
    
        [x, y] = cartesianToSpherical(cloud.Location(k,1), cloud.Location(k,2), cloud.Location(k,3));
        [z_x, z_y] = getPixelPosition(x,y,a_x,a_y);
        p_x = ceil(z_x/a_0 - a_1);
        p_y = ceil(z_y/A_0 - A_1);
    
        if p_x < c && p_y < r && p_x > 0 && p_y > 0
            points_in(end+1,:) = [p_x, p_y];
        end
        
  end

end