function cloud_out = myFuseCameraLidar(im,cloud, intrinsic, tform)
    
    cloud_out = cloud;
    d = size(im);
    rows = d(1);
    cols = d(2);
    coord = [];

    for i = 1:length(cloud.Location)

        % point3D = cloud.Location(i,:);
        % point3D = [point3D'; 1];
        % point3D_cam_coord = tform.A * point3D;
        % point3D_cam_coord(end) = [];
        % pix_loc = intrinsic.K * point3D_cam_coord;
        % pix_loc(end) = [];
        % 
        % 
        % x = abs(round(pix_loc(1)));
        % y = abs(round(pix_loc(2)));
        % 
        % coord(end+1,:) = [x y];
        % 
        % if x < cols && y < rows && x > 0 && y > 0
        % 
        %     r = im(y,x, 1);
        %     g = im(y,x, 2);
        %     b = im(y,x, 3);
        % 
        % else
        % 
        %     r = 0; 
        %     g = 0;
        %     b = 255;
        % 
        % end

        point3D = cloud.Location(i,:);
        % point3D = [point3D'; 1];
    
        [projected, valid] = projectPoints(point3D, intrinsic.K, tform.A, intrinsic.RadialDistortion, [rows cols],true);
        coord(end+1,:) = projected;

        if(~isnan(projected(1)) && ~isnan(projected(2)))

            x = round(projected(1));
            y = round(projected(2));

            if x < cols && y < rows && x > 0 && y > 0
                r = im(y,x, 1);
                g = im(y,x, 2);
                b = im(y,x, 3);
                cloud_out.Color(i,:) = [r g b];
            else
                cloud_out.Color(i,:) = [0 0 255];
            end
        else
            cloud_out.Color(i,:) = [0 0 255];
        end
        

    end
    % imshow(im); hold on; plot(coord(:,1), coord(:,2), 'r+')
end