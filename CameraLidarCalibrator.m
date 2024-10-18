classdef CameraLidarCalibrator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        FilenamesTab                    matlab.ui.container.Tab
        DetectcalibrationboardButton    matlab.ui.control.Button
        CameraIntrinsicsEditField       matlab.ui.control.EditField
        CameraIntrinsicsEditFieldLabel  matlab.ui.control.Label
        SquaresizemmEditField           matlab.ui.control.NumericEditField
        SquaresizemmEditFieldLabel      matlab.ui.control.Label
        PointCloudsfileEditField        matlab.ui.control.EditField
        PointCloudsfileEditFieldLabel   matlab.ui.control.Label
        ImagesfileEditField             matlab.ui.control.EditField
        ImagesfileEditFieldLabel        matlab.ui.control.Label
        EnteryourpathtoimagesandpointcloudsdirectoriesLabel  matlab.ui.control.Label
        DataprepareTab                  matlab.ui.container.Tab
        CalibrateButton                 matlab.ui.control.Button
        ImageAxes                       matlab.ui.control.UIAxes
        ListBox                         matlab.ui.control.ListBox
        ListBoxLabel                    matlab.ui.control.Label
        CloudAxes                          matlab.ui.control.UIAxes
        CalibrationTab                  matlab.ui.container.Tab
        ListBox2                        matlab.ui.control.ListBox
        ListBox2Label                   matlab.ui.control.Label
        UIAxes4                         matlab.ui.control.UIAxes
        UIAxes2_3                       matlab.ui.control.UIAxes
        UIAxes2_2                       matlab.ui.control.UIAxes
        UIAxes2                         matlab.ui.control.UIAxes
        GridLayout                      matlab.ui.container.GridLayout
        Panel_image                           matlab.ui.container.Panel
        Panel_cloud                           matlab.ui.container.Panel
        imageFileNames
        pcFileNames
        cameraIntrinsics
        squareSize
        Image
        Cloud
        Ext_pc
        Ext_im


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
            app.ImagesfileEditFieldLabel.Position = [67 238 63 22];
            app.ImagesfileEditFieldLabel.Text = 'Images files';
           

            % Create ImagesfileEditField
            app.ImagesfileEditField = uieditfield(app.FilenamesTab, 'text');
            app.ImagesfileEditField.Position = [145 238 448 22];
            app.ImagesfileEditField.Value = '/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/images';

            % Create PointCloudsfileEditFieldLabel
            app.PointCloudsfileEditFieldLabel = uilabel(app.FilenamesTab);
            app.PointCloudsfileEditFieldLabel.HorizontalAlignment = 'right';
            app.PointCloudsfileEditFieldLabel.Position = [42 185 92 22];
            app.PointCloudsfileEditFieldLabel.Text = 'Point Clouds files';

            % Create PointCloudsfileEditField
            app.PointCloudsfileEditField = uieditfield(app.FilenamesTab, 'text');
            app.PointCloudsfileEditField.Position = [149 185 448 22];
            app.PointCloudsfileEditField.Value = '/home/lukas/ros2_try/bag_processing/checkerboard_09_25/data_for_calibration/clouds';

            % Create SquaresizemmEditFieldLabel
            app.SquaresizemmEditFieldLabel = uilabel(app.FilenamesTab);
            app.SquaresizemmEditFieldLabel.HorizontalAlignment = 'right';
            app.SquaresizemmEditFieldLabel.Position = [42 84 100 22];
            app.SquaresizemmEditFieldLabel.Text = 'Square size (mm)';

            % Create SquaresizemmEditField
            app.SquaresizemmEditField = uieditfield(app.FilenamesTab, 'numeric');
            app.SquaresizemmEditField.Position = [157 84 118 22];
            app.SquaresizemmEditField.Value = 100;

            % Create CameraIntrinsicsEditFieldLabel
            app.CameraIntrinsicsEditFieldLabel = uilabel(app.FilenamesTab);
            app.CameraIntrinsicsEditFieldLabel.HorizontalAlignment = 'right';
            app.CameraIntrinsicsEditFieldLabel.Position = [36 134 98 22];
            app.CameraIntrinsicsEditFieldLabel.Text = 'Camera Intrinsics';

            % Create CameraIntrinsicsEditField
            app.CameraIntrinsicsEditField = uieditfield(app.FilenamesTab, 'text');
            app.CameraIntrinsicsEditField.Position = [149 134 448 22];
            app.CameraIntrinsicsEditField.Value = '/home/lukas/ros2_try/bag_processing/10_11_24_im_ptCloud/cameraParams_10_11_24.mat';

            % Create DetectcalibrationboardButton
            app.DetectcalibrationboardButton = uibutton(app.FilenamesTab, 'push');
            app.DetectcalibrationboardButton.Position = [221 37 262 23];
            app.DetectcalibrationboardButton.Text = 'Detect calibration board';
            app.DetectcalibrationboardButton.ButtonPushedFcn = @(btn, event)DetectCalibrationBoard(app, event);

            % Create DataprepareTab
            app.DataprepareTab = uitab(app.TabGroup);
            app.DataprepareTab.Title = 'Data prepare';

            % Create Panel Image
            app.Panel_image = uipanel(app.DataprepareTab);
            app.Panel_image.Title = 'Image';
            app.Panel_image.Position = [86 238 433 209];

            app.Panel_cloud = uipanel(app.DataprepareTab);
            app.Panel_cloud.Title = 'Point Cloud';
            app.Panel_cloud.Position = [86 22 433 209];

            % Create UIAxes
            app.CloudAxes = uiaxes(app.Panel_cloud);
            title(app.CloudAxes, 'Point Cloud')
            xlabel(app.CloudAxes, 'X')
            ylabel(app.CloudAxes, 'Y')
            zlabel(app.CloudAxes, 'Z')
            rotate3d(app.CloudAxes, 'on');
            app.CloudAxes.Position = [133 5 221 171];
           % app.CloudAxes.ButtonDownFcn = @(src, event) CloudAxesBtnDwnFnc(app, event);
            app.CloudAxes.ButtonDownFcn = createCallbackFcn(app, @CloudAxesBtnDwnFnc, true);
           

            % Create ListBoxLabel
            app.ListBoxLabel = uilabel(app.DataprepareTab);
            app.ListBoxLabel.HorizontalAlignment = 'right';
            app.ListBoxLabel.Position = [11 427 63 22];
            app.ListBoxLabel.Text = 'file Names';

            % Create ListBox
            app.ListBox = uilistbox(app.DataprepareTab);
            app.ListBox.Position = [11 8 63 442];
            app.ListBox.ValueChangedFcn = @(src, event) listboxCallback(app, event);

            % Create Image
            app.ImageAxes = uiaxes(app.Panel_image);
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Units = 'pixels';
            app.ImageAxes.Position = [135 13 208 161];
            app.ImageAxes.XLimMode = 'manual';  % Lock X-axis limits
            app.ImageAxes.YLimMode = 'manual';  % Lock Y-axis limits
            app.ImageAxes.ZLimMode = 'manual';  % Lock Z-axis limits
                        

            % Create CalibrateButton
            app.CalibrateButton = uibutton(app.DataprepareTab, 'push');
            app.CalibrateButton.Position = [529 353 100 23];
            app.CalibrateButton.Text = 'Calibrate';

            % Create CalibrationTab
            app.CalibrationTab = uitab(app.TabGroup);
            app.CalibrationTab.Title = 'Calibration';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.CalibrationTab);
            title(app.UIAxes2, 'Reprojection error')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [10 51 178 123];

            % Create UIAxes2_2
            app.UIAxes2_2 = uiaxes(app.CalibrationTab);
            title(app.UIAxes2_2, 'Translation error')
            xlabel(app.UIAxes2_2, 'X')
            ylabel(app.UIAxes2_2, 'Y')
            zlabel(app.UIAxes2_2, 'Z')
            app.UIAxes2_2.Position = [202 51 196 118];

            % Create UIAxes2_3
            app.UIAxes2_3 = uiaxes(app.CalibrationTab);
            title(app.UIAxes2_3, 'Rotration error')
            xlabel(app.UIAxes2_3, 'X')
            ylabel(app.UIAxes2_3, 'Y')
            zlabel(app.UIAxes2_3, 'Z')
            app.UIAxes2_3.Position = [413 51 197 118];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.CalibrationTab);
            title(app.UIAxes4, 'Colored Point Cloud')
            xlabel(app.UIAxes4, 'X')
            ylabel(app.UIAxes4, 'Y')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.Position = [129 185 446 257];

            % Create ListBox2Label
            app.ListBox2Label = uilabel(app.CalibrationTab);
            app.ListBox2Label.HorizontalAlignment = 'right';
            app.ListBox2Label.Position = [10 411 54 22];
            app.ListBox2Label.Text = 'List Box2';

            % Create ListBox2
            app.ListBox2 = uilistbox(app.CalibrationTab);
            app.ListBox2.Position = [10 218 100 217];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end



    % App creation and deletion
    methods (Access = public)

        function DetectCalibrationBoard(app, event)
            imageDataPath = app.ImagesfileEditField.Value;
            imds = imageDatastore(imageDataPath);
            app.imageFileNames = imds.Files;

            ptCloudFilePath = app.PointCloudsfileEditField.Value;
            pcds = fileDatastore(ptCloudFilePath,'ReadFcn',@pcread);
            app.pcFileNames = pcds.Files;
            
            parameters = load(app.CameraIntrinsicsEditField.Value);
            app.cameraIntrinsics = struct2cell(parameters);
            app.cameraIntrinsics = app.cameraIntrinsics{1,1};

            app.squareSize = app.SquaresizemmEditField.Value;
            
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
            
            app.Image = imread(strcat(app.ImagesfileEditField.Value,'/',app.ListBox.Value,app.Ext_im));
            imshow(app.Image, 'Parent',app.ImageAxes);

            app.Cloud = pcread(strcat(app.PointCloudsfileEditField.Value,'/',app.ListBox.Value,app.Ext_pc));
            
            scatter3(app.Cloud.Location(:,1),app.Cloud.Location(:,2),app.Cloud.Location(:,3), 'Parent',app.CloudAxes,'Marker','.')
            
            lower = min([app.Cloud.XLimits app.Cloud.YLimits]);
            upper = max([app.Cloud.XLimits app.Cloud.YLimits]);
              
            xlimits = [lower upper];
            ylimits = [lower upper];
            zlimits = app.Cloud.ZLimits;
            set(app.CloudAxes, 'XLim',xlimits, 'YLim', ylimits, 'ZLim',zlimits);
            set(app.CloudAxes,'DataAspectRatio',[1 1 1])

        end


        function CloudAxesBtnDwnFnc(app, event)
            disp("hello")
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