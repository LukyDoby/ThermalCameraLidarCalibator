classdef CameraLidarCalibrator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        FilenamesTab                    matlab.ui.container.Tab
        DetectcalibrationboardButton    matlab.ui.control.Button
        CameraIntrinsicsEditField       matlab.ui.control.EditField
        CameraIntrinsicsBtnSrch         matlab.ui.control.Button
        CameraIntrinsicPath
        CameraIntrinsicsEditFieldLabel  matlab.ui.control.Label
        CameraIntrinsicsPathLabel
        CameraIntrinsicsBtn             matlab.ui.control.Button
        BoardSizeEditField           matlab.ui.control.NumericEditField
        BoardSize      matlab.ui.control.Label
        PointCloudsfileEditField        matlab.ui.control.EditField
        PointCloudsfileEditFieldLabel   matlab.ui.control.Label
        ImagesFolder
        ImagesFolderPath
        CloudFolder
        CloudFolderPath
        ImagesSearchBtn                 matlab.ui.control.Button
        CloudSearchBtn                 matlab.ui.control.Button
        ImagesfileEditFieldLabel        matlab.ui.control.Label
        EnteryourpathtoimagesandpointcloudsdirectoriesLabel  matlab.ui.control.Label
        DataprepareTab                  matlab.ui.container.Tab
        CalibrateButton                 matlab.ui.control.Button
        RemoveButton                   matlab.ui.control.Button
        ImageAxes                       matlab.ui.control.UIAxes
        ListBox                         matlab.ui.control.ListBox
        ListBoxLabel                    matlab.ui.control.Label
        CloudAxes                          matlab.ui.control.UIAxes
        CalibrationTab                  matlab.ui.container.Tab
        ListBox2                        matlab.ui.control.ListBox
        ListBox2Label                   matlab.ui.control.Label
        ColoredCloudAxes                         matlab.ui.control.UIAxes
        RotationErrorAxes                       matlab.ui.control.UIAxes
        TransErrorAxes                       matlab.ui.control.UIAxes
        ReprojErrorAxes                         matlab.ui.control.UIAxes
        GridLayout                      matlab.ui.container.GridLayout
        Panel_image                           matlab.ui.container.Panel
        Panel_cloud                           matlab.ui.container.Panel
        imageFileNames
        pcFileNames
        cameraIntrinsics
        squareSize
        Image
        Cloud
        Image2
        Cloud2
        Ext_pc
        Ext_im
        Tform
        Errors
        BarBaseColor


    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Camera Lidar Calibrator';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 480];

            % Create FilenamesTab
            app.FilenamesTab = uitab(app.TabGroup);
            app.FilenamesTab.Title = 'Filenames';

            % Create EnteryourpathtoimagesandpointcloudsdirectoriesLabel
            app.EnteryourpathtoimagesandpointcloudsdirectoriesLabel = uilabel(app.FilenamesTab);
            app.EnteryourpathtoimagesandpointcloudsdirectoriesLabel.HorizontalAlignment = 'center';
            app.EnteryourpathtoimagesandpointcloudsdirectoriesLabel.FontSize = 18;
            app.EnteryourpathtoimagesandpointcloudsdirectoriesLabel.Position = [41 296 591 66];
            app.EnteryourpathtoimagesandpointcloudsdirectoriesLabel.Text = 'Enter your path to images and point clouds directories';

            % Create ImagesfileEditFieldLabel
            app.ImagesfileEditFieldLabel = uilabel(app.FilenamesTab);
            app.ImagesfileEditFieldLabel.HorizontalAlignment = 'right';
            app.ImagesfileEditFieldLabel.Position = [42 238 100 22];
            app.ImagesfileEditFieldLabel.Text = 'Images files';

            app.ImagesFolderPath = uilabel(app.FilenamesTab);
            app.ImagesFolderPath.HorizontalAlignment = 'right';
            app.ImagesFolderPath.Position = [500 238 600 22];
            app.ImagesFolderPath.Text = '';
            
            app.ImagesSearchBtn = uibutton(app.FilenamesTab, 'push');
            app.ImagesSearchBtn.Position = [200 238 150 22];
            app.ImagesSearchBtn.Text = 'Images Folder';
            app.ImagesSearchBtn.ButtonPushedFcn = @(btn, event)FindImagesFolder(app, event);

            % Create ImagesfileEditField
            % app.ImagesfileEditField = uieditfield(app.FilenamesTab, 'text');
            % app.ImagesfileEditField.Position = [145 238 448 22];
            % app.ImagesfileEditField.Value = '/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/images/used_data';

            % Create PointCloudsfileEditFieldLabel
            app.PointCloudsfileEditFieldLabel = uilabel(app.FilenamesTab);
            app.PointCloudsfileEditFieldLabel.HorizontalAlignment = 'right';
            app.PointCloudsfileEditFieldLabel.Position = [42 185 100 22];
            app.PointCloudsfileEditFieldLabel.Text = 'Point Clouds files';

            app.CloudFolderPath = uilabel(app.FilenamesTab);
            app.CloudFolderPath.HorizontalAlignment = 'right';
            app.CloudFolderPath.Position = [500 185 600 22];
            app.CloudFolderPath.Text = '';
            
            app.CloudSearchBtn = uibutton(app.FilenamesTab, 'push');
            app.CloudSearchBtn.Position = [200 185 150 22];
            app.CloudSearchBtn.Text = 'Point CLoud Folder';
            app.CloudSearchBtn.ButtonPushedFcn = @(btn, event)FindCloudFolder(app, event);

            % Create PointCloudsfileEditField
            % app.PointCloudsfileEditField = uieditfield(app.FilenamesTab, 'text');
            % app.PointCloudsfileEditField.Position = [149 185 448 22];
            % app.PointCloudsfileEditField.Value = '/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/clouds/data_used';

            % Create SquaresizemmEditFieldLabel
            app.BoardSize = uilabel(app.FilenamesTab);
            app.BoardSize.HorizontalAlignment = 'right';
            app.BoardSize.Position = [42 84 100 22];
            app.BoardSize.Text = 'Board Size [height width] mm';

            % Create SquaresizemmEditField
            app.BoardSizeEditField = uieditfield(app.FilenamesTab, 'numeric');
            app.BoardSizeEditField.Position = [157 84 50 22];
            app.BoardSizeEditField.Value = [249 386];

            % Create CameraIntrinsicsEditFieldLabel
            app.CameraIntrinsicsEditFieldLabel = uilabel(app.FilenamesTab);
            app.CameraIntrinsicsEditFieldLabel.HorizontalAlignment = 'right';
            app.CameraIntrinsicsEditFieldLabel.Position = [36 134 100 22];
            app.CameraIntrinsicsEditFieldLabel.Text = 'Camera Intrinsics';

            app.CameraIntrinsicPath = '/home/lukas/ros2_try/bag_processing/calibrationSession_Boson_hlinik_final.mat';

            app.CameraIntrinsicsBtn = uibutton(app.FilenamesTab, 'push');
            app.CameraIntrinsicsBtn.Position = [200 134 150 22];
            app.CameraIntrinsicsBtn.Text = 'Camera Intrinsic';
            app.CameraIntrinsicsBtn.ButtonPushedFcn = @(btn, event)FindCameraIntrinsicsBtnDwn(app, event);

            app.CameraIntrinsicsPathLabel = uilabel(app.FilenamesTab);
            app.CameraIntrinsicsPathLabel.HorizontalAlignment = 'right';
            app.CameraIntrinsicsPathLabel.Position = [500 134 600 22];
            app.CameraIntrinsicsPathLabel.Text = app.CameraIntrinsicPath;

            % Create CameraIntrinsicsEditField
            % app.CameraIntrinsicsEditField = uieditfield(app.FilenamesTab, 'text');
            % app.CameraIntrinsicsEditField.Position = [149 134 448 22];
            % app.CameraIntrinsicsEditField.Value = '/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/cameraParams_10_11_24.mat';

            % Create DetectcalibrationboardButton
            app.DetectcalibrationboardButton = uibutton(app.FilenamesTab, 'push');
            app.DetectcalibrationboardButton.Position = [221 37 262 23];
            app.DetectcalibrationboardButton.Text = 'Detect calibration board';
            app.DetectcalibrationboardButton.ButtonPushedFcn = @(btn, event)DetectCalibrationBoard(app, event);

            % Create DataprepareTab
            app.DataprepareTab = uitab(app.TabGroup);
            app.DataprepareTab.Title = 'Data prepare';

            % Create UIAxes
            app.CloudAxes = uiaxes(app.DataprepareTab);
            title(app.CloudAxes, 'Point Cloud')
            xlabel(app.CloudAxes, 'X')
            ylabel(app.CloudAxes, 'Y')
            zlabel(app.CloudAxes, 'Z')
            app.CloudAxes.Position = [133 5 221 171];
           % app.CloudAxes.ButtonDownFcn = @(src, event) CloudAxesBtnDwnFnc(app, event);
           % app.CloudAxes.ButtonDownFcn = createCallbackFcn(app, @CloudAxesBtnDwnFnc, true);
           

            % Create ListBoxLabel
            app.ListBoxLabel = uilabel(app.DataprepareTab);
            app.ListBoxLabel.HorizontalAlignment = 'right';
            app.ListBoxLabel.Position = [11 427 63 22];
            app.ListBoxLabel.Text = 'file Names';

            % Create ListBox
            app.ListBox = uilistbox(app.DataprepareTab);
            app.ListBox.Position = [11 8 63 442];
            app.ListBox.ValueChangedFcn = @(src, event) listboxCallback(app, event);
            app.ListBox.Multiselect = "on";

            % Create Image
            app.ImageAxes = uiaxes(app.DataprepareTab);
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Units = 'pixels';
            app.ImageAxes.Position = [135 300 208 161];

            % Create RemoveButton
            app.RemoveButton = uibutton(app.DataprepareTab, 'push');
            app.RemoveButton.Position = [80 353 100 23];
            app.RemoveButton.Text = 'Remove';
            app.RemoveButton.ButtonPushedFcn = @(btn, event)RemoveBtnDwn(app, event);
                        

            % Create CalibrateButton
            app.CalibrateButton = uibutton(app.DataprepareTab, 'push');
            app.CalibrateButton.Position = [529 353 100 23];
            app.CalibrateButton.Text = 'Calibrate';
            app.CalibrateButton.ButtonPushedFcn = @(btn, event)CalibrateButtonDwn(app, event);

            % Create CalibrationTab
            app.CalibrationTab = uitab(app.TabGroup);
            app.CalibrationTab.Title = 'Calibration';

            % Create UIAxes2
            app.ReprojErrorAxes = uiaxes(app.CalibrationTab);
            title(app.ReprojErrorAxes, 'Reprojection error')
            xlabel(app.ReprojErrorAxes, 'X')
            ylabel(app.ReprojErrorAxes, 'Y')
            zlabel(app.ReprojErrorAxes, 'Z')
            app.ReprojErrorAxes.Position = [10 51 178 123];

            % Create UIAxes2_2
            app.TransErrorAxes = uiaxes(app.CalibrationTab);
            title(app.TransErrorAxes, 'Translation error')
            xlabel(app.TransErrorAxes, 'X')
            ylabel(app.TransErrorAxes, 'Y')
            zlabel(app.TransErrorAxes, 'Z')
            app.TransErrorAxes.Position = [202 51 196 118];

            % Create UIAxes2_3
            app.RotationErrorAxes = uiaxes(app.CalibrationTab);
            title(app.RotationErrorAxes, 'Rotration error')
            xlabel(app.RotationErrorAxes, 'X')
            ylabel(app.RotationErrorAxes, 'Y')
            zlabel(app.RotationErrorAxes, 'Z')
            app.RotationErrorAxes.Position = [413 51 197 118];

            % Create UIAxes4
            app.ColoredCloudAxes = uiaxes(app.CalibrationTab);
            title(app.ColoredCloudAxes, 'Colored Point Cloud')
            xlabel(app.ColoredCloudAxes, 'X')
            ylabel(app.ColoredCloudAxes, 'Y')
            zlabel(app.ColoredCloudAxes, 'Z')
            app.ColoredCloudAxes.Position = [129 185 446 257];

            % Create ListBox2Label
            app.ListBox2Label = uilabel(app.CalibrationTab);
            app.ListBox2Label.HorizontalAlignment = 'right';
            app.ListBox2Label.Position = [10 411 54 22];
            app.ListBox2Label.Text = 'List Box2';
           

            % Create ListBox2
            app.ListBox2 = uilistbox(app.CalibrationTab);
            app.ListBox2.Position = [10 218 100 217];
            app.ListBox2.ValueChangedFcn = @(btn,event)ListBox2BtnDwnFunction(app,event);

            app.BarBaseColor = [0 0.4470 0.7410];
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        function FindImagesFolder(app, event)

            app.ImagesFolder = uigetdir('/home/lukas/ros2_try/bag_processing/');
            app.ImagesFolderPath.Text = app.ImagesFolder;
        end

        function FindCloudFolder(app, event)
            app.CloudFolder = uigetdir('/home/lukas/ros2_try/bag_processing/');
            app.CloudFolderPath.Text = app.CloudFolder;
        end

        function FindCameraIntrinsicsBtnDwn(app, event)
            [app.CameraIntrinsicPath, location] = uigetfile;
            app.CameraIntrinsicPath = strcat(location,app.CameraIntrinsicPath);
            app.CameraIntrinsicsPathLabel.Text = app.CameraIntrinsicPath;

        end

        function DetectCalibrationBoard(app, event)
            imageDataPath = app.ImagesFolder;
            imds = imageDatastore(imageDataPath);
            app.imageFileNames = imds.Files;

            ptCloudFilePath = app.CloudFolder;
            pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
            app.pcFileNames = pcds.Files;
            
            parameters = load(app.CameraIntrinsicPath);
            app.cameraIntrinsics = struct2cell(parameters);
            app.cameraIntrinsics = app.cameraIntrinsics{1,1};
            
            cellOfImageNames = cell(1,length(app.imageFileNames));
            %cellOfCloudNames = cell(1,length(app.pcFileNames));

            [~,~ , app.Ext_pc] = fileparts(app.pcFileNames{1});
            [~,~ , app.Ext_im] = fileparts(app.imageFileNames{1});

            for i = 1:length(app.imageFileNames)
    
                [~, filename_im, ~] = fileparts(app.imageFileNames{i});
                cellOfImageNames{i} = strcat(filename_im);
                
            end

            app.ListBox.Items = cellOfImageNames;
            listboxCallback(app);


        end

        function listboxCallback(app, event)
            if isscalar(app.ListBox.Value)
         
                im_Name = strcat(app.ImagesfileEditField.Value,'/',app.ListBox.Value{1},app.Ext_im);
                if ischar(im_Name)
                    app.Image = imread(im_Name);
                else
                    app.Image = imread(im_Name{1});
                end
              
                imshow(app.Image, 'Parent',app.ImageAxes);
    
                cloud_Name = strcat(app.PointCloudsfileEditField.Value,'/',app.ListBox.Value{1},app.Ext_pc);
                
                if ischar(cloud_Name)
                    app.Cloud = pcread(cloud_Name);
                else
                    app.Cloud = pcread(cloud_Name{1});
                end
                   
                pcshow(app.Cloud, 'Parent',app.CloudAxes);
    
               % app.ListBox.Multiselect = "on";
                
            end
        
        end


        function CloudAxesBtnDwnFnc(app, event)
            disp("hello")
        end
        
        
        function RemoveBtnDwn(app, event)

            i = length(app.ListBox.Value);

            while i > 0
                im_Name = strcat(app.ImagesfileEditField.Value,'/',app.ListBox.Value{i},app.Ext_im);
                cloud_Name = strcat(app.PointCloudsfileEditField.Value,'/',app.ListBox.Value{i},app.Ext_pc);
                app.imageFileNames(find(strcmp(app.imageFileNames, im_Name))) = [];
                app.pcFileNames(find(strcmp(app.pcFileNames, cloud_Name))) = [];
                app.ListBox.Items(find(strcmp(app.ListBox.Items, app.ListBox.Value{i}))) = [];
                
                i = i-1;
        
            end

            listboxCallback(app);

        end
        
   
        
        function CalibrateButtonDwn(app, event)

            %% Estimate the checkerboard corner coordinates for the images.

            [imageCorners3d,planeDimension,imagesUsed] = estimateCheckerboardCorners3d( ...
                app.imageFileNames,app.cameraIntrinsics,app.squareSize);


            app.pcFileNames = app.pcFileNames(imagesUsed);

            %% Detect the checkerboard planes in the filtered point clouds using the plane parameters planeDimension.

            [lidarCheckerboardPlanes,framesUsed] = detectRectangularPlanePoints( ...
            app.pcFileNames,planeDimension,'RemoveGround',true);

            %% Extract the images, checkerboard corners, and point clouds in which you detected features.

            app.imageFileNames = app.imageFileNames(imagesUsed);
            app.imageFileNames = app.imageFileNames(framesUsed);
            app.pcFileNames = app.pcFileNames(framesUsed);
            imageCorners3d = imageCorners3d(:,:,framesUsed);

            %% Estimate Transformation

            [app.Tform,app.Errors] = estimateLidarCameraTransform(lidarCheckerboardPlanes, ...
            imageCorners3d,app.cameraIntrinsics);

            bar(app.Errors.TranslationError, 'Parent', app.TransErrorAxes);
            xlabel(app.TransErrorAxes,'Frame Number');

            bar(app.Errors.RotationError, 'Parent', app.RotationErrorAxes);
            xlabel(app.RotationErrorAxes,'Frame Number');

            bar(app.Errors.ReprojectionError, 'Parent', app.ReprojErrorAxes);
            xlabel(app.ReprojErrorAxes,'Frame Number');

            app.ListBox2.Items = app.ListBox.Items;



        end

        function ListBox2BtnDwnFunction(app,event)
         
                im_Name = strcat(app.ImagesfileEditField.Value,'/',app.ListBox2.Value,app.Ext_im);
                
                app.Image2 = imread(im_Name);
                
                cloud_Name = strcat(app.PointCloudsfileEditField.Value,'/',app.ListBox2.Value,app.Ext_pc);
                
                app.Cloud2 = pcread(cloud_Name);
               
                app.Cloud2 = myFuseCameraLidar(app.Image2,app.Cloud2, app.cameraIntrinsics, app.Tform);
                pcshow(app.Cloud2,'Parent',app.ColoredCloudAxes); 

                %% Settings color to bars in errors
                 app.ReprojErrorAxes.Children.CData =  ones(length(app.ListBox2.Items),1) * app.BarBaseColor;
                 app.TransErrorAxes.Children.CData =  ones(length(app.ListBox2.Items),1) * app.BarBaseColor;
                 app.RotationErrorAxes.Children.CData =  ones(length(app.ListBox2.Items),1) * app.BarBaseColor;

                app.ReprojErrorAxes.Children.CData(app.ListBox2.ValueIndex,:) = [0 0 1];
                app.ReprojErrorAxes.Children.FaceColor = 'flat';
                app.TransErrorAxes.Children.CData(app.ListBox2.ValueIndex,:) = [0 0 1];
                app.TransErrorAxes.Children.FaceColor = "flat";
                app.RotationErrorAxes.Children.CData(app.ListBox2.ValueIndex,:) = [0 0 1];
                app.RotationErrorAxes.Children.FaceColor = "flat";

        end
        
      
        % Construct app
        function app = CameraLidarCalibrator

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end