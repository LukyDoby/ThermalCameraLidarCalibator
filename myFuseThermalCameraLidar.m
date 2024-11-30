function cloud_out = myFuseThermalCameraLidar(im,cloud, intrinsic, tform)
    
    cloud_out = cloud;
    im = undistortImage(im, intrinsic);
    d = size(im);
    rows = d(1);
    cols = d(2);
    coord = [];

    for i = 1:length(cloud.Location)

        point3D = cloud.Location(i,:);
        % point3D = [point3D'; 1];
    
        [projected, valid] = projectPoints(point3D, intrinsic.K, tform.A, intrinsic.RadialDistortion, [rows cols],true);
        coord(end+1,:) = projected;

        if(~isnan(projected(1)) && ~isnan(projected(2)))

            x = round(projected(1));
            y = round(projected(2));

            if x < cols && y < rows && x > 0 && y > 0
                val = im(y,x);
                cloud_out.Color(i,:) = [val val val];
            else
                cloud_out.Color(i,:) = [0 0 255];
            end
        else
            cloud_out.Color(i,:) = [0 0 255];
        end
        

    end
end