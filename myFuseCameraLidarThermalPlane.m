function [coord, im_out] = myFuseCameraLidarThermalPlane(im,cloud, intrinsic, tform)
    
    im_out = im;
    im_out = undistortImage(im_out, intrinsic);
    d = size(im_out);
    rows = d(1);
    cols = d(2);
    coord = [];

    for i = 1:length(cloud.Location)

        point3D = cloud.Location(i,:);
        % point3D = [point3D'; 1];
    
        [projected] = projectPoints(point3D, intrinsic.K, tform.A, intrinsic.RadialDistortion, [rows cols],true);
    
        if(~isnan(projected(1)) && ~isnan(projected(2)))

            x = round(projected(1));
            y = round(projected(2));

            if x < cols && y < rows && x > 0 && y > 0
                coord(end+1,:) = projected;
            end

        end
        

    end
end