function points3D_cloud = transformPointsToCloudCoordinates(points3D)

points3D = rotz(180) * points3D;
points3D = rotz(180)*points3D;
points3D_extr = rotx(90)*points3D;
points3D_extr = rotz(180)*points3D_extr;
points3D_cloud = rotx(180)*points3D_extr;
points3D_cloud = rotz(90)*points3D_cloud;
points3D_cloud = points3D_cloud./1000;
    
end