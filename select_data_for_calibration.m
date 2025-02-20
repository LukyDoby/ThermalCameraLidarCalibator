%% Select data for sphere calibration - copy coresponding clouds to a folder
clear; clc; close all;
cloudExt = '.ply';
fileName = "/media/lukas/T9/Dobrovolny/17_12_24_bags/checker6";
imageFile = dir(fullfile(fileName,"/data_for_calibration/images/"));
cloudFile_orig = fullfile(fileName,"PointClouds/");
cloudFile_dest = fullfile(fileName,"/data_for_calibration/clouds/");

for i = 1:length(imageFile)

    if imageFile(i).bytes ~= 0

        imFileName = fullfile(fileName, "/PointClouds/",imageFile(i).name);
        [~,cloudFileName] = fileparts(imFileName);
        cloudFileName = fullfile(cloudFile_orig,strcat(cloudFileName, cloudExt));
        
        status = copyfile(cloudFileName, cloudFile_dest);

        if ~status
            disp("unable to copy the file!");
        end


    end

end
