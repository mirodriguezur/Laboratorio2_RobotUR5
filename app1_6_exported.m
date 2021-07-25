classdef app1_6_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        GridLayout                    matlab.ui.container.GridLayout
        LeftPanel                     matlab.ui.container.Panel
        q1SliderLabel                 matlab.ui.control.Label
        q1Slider                      matlab.ui.control.Slider
        q2SliderLabel                 matlab.ui.control.Label
        q2Slider                      matlab.ui.control.Slider
        q3SliderLabel                 matlab.ui.control.Label
        q3Slider                      matlab.ui.control.Slider
        q4SliderLabel                 matlab.ui.control.Label
        q4Slider                      matlab.ui.control.Slider
        q5SliderLabel                 matlab.ui.control.Label
        q5Slider                      matlab.ui.control.Slider
        q6SliderLabel                 matlab.ui.control.Label
        q6Slider                      matlab.ui.control.Slider
        angulosdearticulacinradLabel  matlab.ui.control.Label
        Label_13                      matlab.ui.control.Label
        Label_14                      matlab.ui.control.Label
        Label_15                      matlab.ui.control.Label
        Label_16                      matlab.ui.control.Label
        Label_17                      matlab.ui.control.Label
        Label_18                      matlab.ui.control.Label
        HomeButton                    matlab.ui.control.StateButton
        Spinner                       matlab.ui.control.Spinner
        Spinner_2                     matlab.ui.control.Spinner
        Spinner_3                     matlab.ui.control.Spinner
        Spinner_4                     matlab.ui.control.Spinner
        Spinner_5                     matlab.ui.control.Spinner
        Spinner_6                     matlab.ui.control.Spinner
        RightPanel                    matlab.ui.container.Panel
        xLabel                        matlab.ui.control.Label
        yLabel                        matlab.ui.control.Label
        zLabel                        matlab.ui.control.Label
        Label                         matlab.ui.control.Label
        Label_2                       matlab.ui.control.Label
        Label_3                       matlab.ui.control.Label
        rollLabel                     matlab.ui.control.Label
        pitchLabel                    matlab.ui.control.Label
        yawLabel                      matlab.ui.control.Label
        Label_4                       matlab.ui.control.Label
        Label_5                       matlab.ui.control.Label
        Label_6                       matlab.ui.control.Label
        PosicinefectorfinalmLabel     matlab.ui.control.Label
        xLabel_2                      matlab.ui.control.Label
        yLabel_2                      matlab.ui.control.Label
        zLabel_2                      matlab.ui.control.Label
        Label_7                       matlab.ui.control.Label
        Label_8                       matlab.ui.control.Label
        Label_9                       matlab.ui.control.Label
        rollLabel_2                   matlab.ui.control.Label
        pitchLabel_2                  matlab.ui.control.Label
        yawLabel_2                    matlab.ui.control.Label
        Label_10                      matlab.ui.control.Label
        Label_11                      matlab.ui.control.Label
        Label_12                      matlab.ui.control.Label
        PosicinefectorfinalmLabel_2   matlab.ui.control.Label
        UIAxes3                       matlab.ui.control.UIAxes
        UIAxes4                       matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = private)
        ur5 = loadrobot("universalUR5",'DataFormat','row','Gravity',[0 0 -9.81]) % ur5 from RST
        q1=0;
        q2=0;
        q3=0;
        q4=0;
        q5=0;
        q6=0;
        L1 = 0.089159; L2 = 0.13585; L3 = 0.425; L4 = 0.1197; 
        L5 = 0.39225; L6 = 0.09365; L7=  0.09465; L8= 0.0823; 
        L9 = 0; %L9 Es la distancia del Tool
        UR5_RVC;
    end
    
    %deg()

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           addpath 'C:\Program Files\MATLAB\R2020b\toolbox\rvctools'
           startup_rvc
           
          
            
            %% empezar RST
            %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,app.ur5.homeConfiguration,'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            
            transform = getTransform(app.ur5,[0 0 0 0 0 0], 'tool0');
            
             app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
            
            gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
           
            
             %% INICIALIZAR TOOLBOX PETER CORKE

             
           L(1) = Link('revolute','alpha',0,'a',0,'d',app.L1,'offset',0,'modified','qlim',[-2*pi 2*pi]);
           L(2) = Link('revolute','alpha',-pi/2,'a',0,'d',app.L2,'offset',0,'modified','qlim',[-2*pi 2*pi]);
           L(3) = Link('revolute','alpha',0,'a',app.L3,'d', - app.L4,'offset',0,'modified','qlim',[-2*pi 2*pi]);
           L(4) = Link('revolute','alpha',0,'a',app.L5,'d',app.L6,'offset',-pi,'modified','qlim',[-2*pi 2*pi]);
           L(5) = Link('revolute','alpha',pi/2,'a',0,'d',app.L7,'offset',0,'modified','qlim',[-2*pi 2*pi]);
           L(6) = Link('revolute','alpha',-pi/2,'a',0,'d',app.L8,'offset',0,'modified','qlim',[-2*pi 2*pi]);
            
            app.UR5_RVC = SerialLink(L,'name', 'RRRRRR');
            app.UR5_RVC.tool = [ 1 0 0 0; 0 1 0 0; 0 0 1 app.L9; 0 0 0 1];
           
            %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [0 0 0 0 0 0],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
            
            
            Tc = app.UR5_RVC.fkine([0 0 0 0 0 0]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
            
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {553, 553};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {255, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Value changed function: q1Slider
        function q1SliderValueChanged(app, event)
            value1 = app.q1Slider.Value;
            %app.EditField.set = value1;
            %value1 = app.EditField.ValueChangedFcn;
            
            
            app.q1 = value1;
            app.Spinner.Value = value1;
                        
            app.Label_13.Text= num2str(app.q1);
            app.Label_14.Text= num2str(app.q2);
            app.Label_15.Text= num2str(app.q3);
            app.Label_16.Text= num2str(app.q4);
            app.Label_17.Text= num2str(app.q5);
            app.Label_18.Text= num2str(app.q6);
            
            %% RST MATLAB 
             %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            
            
            transform = getTransform(app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'tool0');
           
            app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
            
             gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
            
            %% RVC
            %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
            
            
             Tc = app.UR5_RVC.fkine([app.q1 app.q2 app.q3 app.q4 app.q5 app.q6]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
        end

        % Value changed function: q2Slider
        function q2SliderValueChanged(app, event)
            value = app.q2Slider.Value;
            app.q2 = value;
            app.Spinner_2.Value = value;
            
            app.Label_13.Text= num2str(app.q1);
            app.Label_14.Text= num2str(app.q2);
            app.Label_15.Text= num2str(app.q3);
            app.Label_16.Text= num2str(app.q4);
            app.Label_17.Text= num2str(app.q5);
            app.Label_18.Text= num2str(app.q6);
            
            %%RST
            
              %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            transform = getTransform(app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'tool0');
            
            app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
            
             gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
            
            %% RVC
            
            %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
            
             Tc = app.UR5_RVC.fkine([app.q1 app.q2 app.q3 app.q4 app.q5 app.q6]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
        end

        % Value changed function: q3Slider
        function q3SliderValueChanged(app, event)
            value = app.q3Slider.Value;
            app.q3 = value;
            
            app.Spinner_3.Value = value;
            
            app.Label_13.Text= num2str(app.q1);
            app.Label_14.Text= num2str(app.q2);
            app.Label_15.Text= num2str(app.q3);
            app.Label_16.Text= num2str(app.q4);
            app.Label_17.Text= num2str(app.q5);
            app.Label_18.Text= num2str(app.q6);
            
            %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            transform = getTransform(app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'tool0');
            
            app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
             gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
            
            %%RVC
            
            %% RVC
            
            %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
            
             Tc = app.UR5_RVC.fkine([app.q1 app.q2 app.q3 app.q4 app.q5 app.q6]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
        end

        % Value changed function: q4Slider
        function q4SliderValueChanged(app, event)
             value = app.q4Slider.Value;
            app.q4 = value;
            app.Spinner_4.Value = value;
            
            app.Label_13.Text= num2str(app.q1);
            app.Label_14.Text= num2str(app.q2);
            app.Label_15.Text= num2str(app.q3);
            app.Label_16.Text= num2str(app.q4);
            app.Label_17.Text= num2str(app.q5);
            app.Label_18.Text= num2str(app.q6);
            
               %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            transform = getTransform(app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'tool0');
            
            app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
            
             gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
            
            %RVC
            
            %% RVC
            %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
            
            
             Tc = app.UR5_RVC.fkine([app.q1 app.q2 app.q3 app.q4 app.q5 app.q6]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
        end

        % Value changed function: q5Slider
        function q5SliderValueChanged(app, event)
            value = app.q5Slider.Value;
            app.q5 = value;
            app.Spinner_5.Value = value;
            
            app.Label_13.Text= num2str(app.q1);
            app.Label_14.Text= num2str(app.q2);
            app.Label_15.Text= num2str(app.q3);
            app.Label_16.Text= num2str(app.q4);
            app.Label_17.Text= num2str(app.q5);
            app.Label_18.Text= num2str(app.q6);
            
               %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            transform = getTransform(app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'tool0');
            
            app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
            
             gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
            
            %% RVC
            
            %% RVC
            
            %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
            
             Tc = app.UR5_RVC.fkine([app.q1 app.q2 app.q3 app.q4 app.q5 app.q6]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
        end

        % Value changed function: q6Slider
        function q6SliderValueChanged(app, event)
            value = app.q6Slider.Value;
            app.q6 = value;
            app.Spinner_6.Value = value;
            
            app.Label_13.Text= num2str(app.q1);
            app.Label_14.Text= num2str(app.q2);
            app.Label_15.Text= num2str(app.q3);
            app.Label_16.Text= num2str(app.q4);
            app.Label_17.Text= num2str(app.q5);
            app.Label_18.Text= num2str(app.q6);
            
            %%RST
            
               %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            transform = getTransform(app.ur5,[app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'tool0');
            
            app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
            
             gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
            
            
            %%RVC
            
            %% RVC
            
            %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [app.q1 app.q2 app.q3 app.q4 app.q5 app.q6],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
             Tc = app.UR5_RVC.fkine([app.q1 app.q2 app.q3 app.q4 app.q5 app.q6]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
        end

        % Value changed function: HomeButton
        function HomeButtonValueChanged(app, event)
            value = app.HomeButton.Value;
            if value == 1
                  %% empezar RST
            %figure(1)
            axis(app.UIAxes3,'off')
            title(app.UIAxes3, ["Universal robots UR5 (RST)"]);
            xlabel(app.UIAxes3, []);
            ylabel(app.UIAxes3, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            show (app.ur5,app.ur5.homeConfiguration,'PreservePlot',false,'Frames','on');
            axis([-1,1,-1,1,-1,1])
            frame =getframe(gcf);
            [image, Map ]= frame2im(frame);
            %imshow(image ,"Parent", app.UIAxes3)
            
            
            % Display image and stretch to fill axes
            I = imshow(image, 'Parent', app.UIAxes3, ...
                'XData', [1 app.UIAxes3.Position(3)], ...
                'YData', [1 app.UIAxes3.Position(4)]);
            % Set limits of axes
            app.UIAxes3.XLim = [0 I.XData(2)];
            app.UIAxes3.YLim = [0 I.YData(2)];
            
            
            transform = getTransform(app.ur5,[0 0 0 0 0 0], 'tool0');
            
             app.Label.Text= num2str(transform(1,4));
            app.Label_2.Text= num2str(transform(2,4));
            app.Label_3.Text= num2str(transform(3,4));
            
            gen_RST = tr2rpy(transform,'deg');
            app.Label_4.Text= num2str(gen_RST(1));
            app.Label_5.Text= num2str(gen_RST(2));
            app.Label_6.Text= num2str(gen_RST(3));
           
             %figure(2)
            axis(app.UIAxes4,'off')
            title(app.UIAxes4, ["Universal robots UR5 (RVC)"]);
            xlabel(app.UIAxes4, []);
            ylabel(app.UIAxes4, []);
            app.UIAxes3.XAxis.TickLabels = {};
            app.UIAxes3.YAxis.TickLabels = {};
            app.UR5_RVC.plot( [0 0 0 0 0 0],'workspace',[-5 5 -5 5 -1 3],'noa','view',[20 25]);
            axis([-1,1,-1,1,-1,1])
            frame2 =getframe(gcf);
            [image2, Map ]= frame2im(frame2);
            %imshow(image2 ,"Parent", app.UIAxes4)
            
             % Display image and stretch to fill axes
            I2 = imshow(image2, 'Parent', app.UIAxes4, ...
                'XData', [1 app.UIAxes4.Position(3)], ...
                'YData', [1 app.UIAxes4.Position(4)]);
            % Set limits of axes
            app.UIAxes4.XLim = [0 I2.XData(2)];
            app.UIAxes4.YLim = [0 I2.YData(2)];
            
            
            Tc = app.UR5_RVC.fkine([0 0 0 0 0 0]); % Cinemática directa del roboT
            gen_RVC=[transl(Tc)', tr2rpy(Tc,'deg')];
            
            app.Label_7.Text= num2str(gen_RVC(1));
            app.Label_8.Text= num2str(gen_RVC(2));
            app.Label_9.Text= num2str(gen_RVC(3));
            app.Label_10.Text= num2str(gen_RVC(4));
            app.Label_11.Text= num2str(gen_RVC(5));
            app.Label_12.Text= num2str(gen_RVC(6));
            
            end
        end

        % Value changed function: Spinner
        function SpinnerValueChanged(app, event)
            value = app.Spinner.Value;
            app.q1Slider.Value = value;
        end

        % Value changed function: Spinner_2
        function Spinner_2ValueChanged(app, event)
            value = app.Spinner_2.Value;
            app.q2Slider.Value = value;
        end

        % Value changed function: Spinner_3
        function Spinner_3ValueChanged(app, event)
            value = app.Spinner_3.Value;
            app.q3Slider.Value = value;
        end

        % Value changed function: Spinner_4
        function Spinner_4ValueChanged(app, event)
            value = app.Spinner_4.Value;
            app.q4Slider.Value = value;
        end

        % Value changed function: Spinner_5
        function Spinner_5ValueChanged(app, event)
            value = app.Spinner_5.Value;
            app.q5Slider.Value = value;
        end

        % Value changed function: Spinner_6
        function Spinner_6ValueChanged(app, event)
            value = app.Spinner_6.Value;
            app.q6Slider.Value = value;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1319 553];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {255, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create q1SliderLabel
            app.q1SliderLabel = uilabel(app.LeftPanel);
            app.q1SliderLabel.HorizontalAlignment = 'right';
            app.q1SliderLabel.Position = [27 479 25 22];
            app.q1SliderLabel.Text = 'q1';

            % Create q1Slider
            app.q1Slider = uislider(app.LeftPanel);
            app.q1Slider.Limits = [-6.28 6.28];
            app.q1Slider.ValueChangedFcn = createCallbackFcn(app, @q1SliderValueChanged, true);
            app.q1Slider.MinorTicks = [-6.28 -5.78 -5.28 -4.78 -4.28 -3.78 -3.28 -2.78 -2.28 -1.78 -1.28 -0.78 -0.28 0.22 0.72 1.22 1.72 2.22 2.72 3.22 3.72 4.22 4.72 5.22 5.72 6.28];
            app.q1Slider.Position = [20 467 218 3];

            % Create q2SliderLabel
            app.q2SliderLabel = uilabel(app.LeftPanel);
            app.q2SliderLabel.HorizontalAlignment = 'right';
            app.q2SliderLabel.Position = [27 397 25 22];
            app.q2SliderLabel.Text = 'q2';

            % Create q2Slider
            app.q2Slider = uislider(app.LeftPanel);
            app.q2Slider.Limits = [-6.28 6.28];
            app.q2Slider.ValueChangedFcn = createCallbackFcn(app, @q2SliderValueChanged, true);
            app.q2Slider.MinorTicks = [-6.28 -5.78 -5.28 -4.78 -4.28 -3.78 -3.28 -2.78 -2.28 -1.78 -1.28 -0.78 -0.28 0.22 0.72 1.22 1.72 2.22 2.72 3.22 3.72 4.22 4.72 5.22 5.72 6.28];
            app.q2Slider.Position = [20 382 218 3];

            % Create q3SliderLabel
            app.q3SliderLabel = uilabel(app.LeftPanel);
            app.q3SliderLabel.HorizontalAlignment = 'right';
            app.q3SliderLabel.Position = [24 313 25 22];
            app.q3SliderLabel.Text = 'q3';

            % Create q3Slider
            app.q3Slider = uislider(app.LeftPanel);
            app.q3Slider.Limits = [-6.28 6.28];
            app.q3Slider.ValueChangedFcn = createCallbackFcn(app, @q3SliderValueChanged, true);
            app.q3Slider.Position = [20 303 218 3];

            % Create q4SliderLabel
            app.q4SliderLabel = uilabel(app.LeftPanel);
            app.q4SliderLabel.HorizontalAlignment = 'right';
            app.q4SliderLabel.Position = [24 233 25 22];
            app.q4SliderLabel.Text = 'q4';

            % Create q4Slider
            app.q4Slider = uislider(app.LeftPanel);
            app.q4Slider.Limits = [-6.28 6.28];
            app.q4Slider.ValueChangedFcn = createCallbackFcn(app, @q4SliderValueChanged, true);
            app.q4Slider.MinorTicks = [-6.28 -5.78 -5.28 -4.78 -4.28 -3.78 -3.28 -2.78 -2.28 -1.78 -1.28 -0.78 -0.28 0.22 0.72 1.22 1.72 2.22 2.72 3.22 3.72 4.22 4.72 5.22 5.72 6.28];
            app.q4Slider.Position = [20 222 218 3];

            % Create q5SliderLabel
            app.q5SliderLabel = uilabel(app.LeftPanel);
            app.q5SliderLabel.HorizontalAlignment = 'right';
            app.q5SliderLabel.Position = [24 155 25 22];
            app.q5SliderLabel.Text = 'q5';

            % Create q5Slider
            app.q5Slider = uislider(app.LeftPanel);
            app.q5Slider.Limits = [-6.28 6.28];
            app.q5Slider.ValueChangedFcn = createCallbackFcn(app, @q5SliderValueChanged, true);
            app.q5Slider.Position = [20 143 218 3];

            % Create q6SliderLabel
            app.q6SliderLabel = uilabel(app.LeftPanel);
            app.q6SliderLabel.HorizontalAlignment = 'right';
            app.q6SliderLabel.Position = [28 70 25 22];
            app.q6SliderLabel.Text = 'q6';

            % Create q6Slider
            app.q6Slider = uislider(app.LeftPanel);
            app.q6Slider.Limits = [-6.28 6.28];
            app.q6Slider.ValueChangedFcn = createCallbackFcn(app, @q6SliderValueChanged, true);
            app.q6Slider.Position = [20 59 218 3];

            % Create angulosdearticulacinradLabel
            app.angulosdearticulacinradLabel = uilabel(app.LeftPanel);
            app.angulosdearticulacinradLabel.Position = [11 515 157 22];
            app.angulosdearticulacinradLabel.Text = 'angulos de articulación (rad)';

            % Create Label_13
            app.Label_13 = uilabel(app.LeftPanel);
            app.Label_13.Position = [78 479 59 22];
            app.Label_13.Text = '0';

            % Create Label_14
            app.Label_14 = uilabel(app.LeftPanel);
            app.Label_14.Position = [78 397 59 22];
            app.Label_14.Text = '0';

            % Create Label_15
            app.Label_15 = uilabel(app.LeftPanel);
            app.Label_15.Position = [78 313 59 22];
            app.Label_15.Text = '0';

            % Create Label_16
            app.Label_16 = uilabel(app.LeftPanel);
            app.Label_16.Position = [78 233 59 22];
            app.Label_16.Text = '0';

            % Create Label_17
            app.Label_17 = uilabel(app.LeftPanel);
            app.Label_17.Position = [78 155 59 22];
            app.Label_17.Text = '0';

            % Create Label_18
            app.Label_18 = uilabel(app.LeftPanel);
            app.Label_18.Position = [78 70 59 22];
            app.Label_18.Text = '0';

            % Create HomeButton
            app.HomeButton = uibutton(app.LeftPanel, 'state');
            app.HomeButton.ValueChangedFcn = createCallbackFcn(app, @HomeButtonValueChanged, true);
            app.HomeButton.Text = 'Home';
            app.HomeButton.Position = [183 515 64 22];

            % Create Spinner
            app.Spinner = uispinner(app.LeftPanel);
            app.Spinner.ValueChangedFcn = createCallbackFcn(app, @SpinnerValueChanged, true);
            app.Spinner.Position = [136 479 100 22];

            % Create Spinner_2
            app.Spinner_2 = uispinner(app.LeftPanel);
            app.Spinner_2.ValueChangedFcn = createCallbackFcn(app, @Spinner_2ValueChanged, true);
            app.Spinner_2.Position = [138 397 100 22];

            % Create Spinner_3
            app.Spinner_3 = uispinner(app.LeftPanel);
            app.Spinner_3.ValueChangedFcn = createCallbackFcn(app, @Spinner_3ValueChanged, true);
            app.Spinner_3.Position = [141 313 100 22];

            % Create Spinner_4
            app.Spinner_4 = uispinner(app.LeftPanel);
            app.Spinner_4.ValueChangedFcn = createCallbackFcn(app, @Spinner_4ValueChanged, true);
            app.Spinner_4.Position = [141 233 100 22];

            % Create Spinner_5
            app.Spinner_5 = uispinner(app.LeftPanel);
            app.Spinner_5.ValueChangedFcn = createCallbackFcn(app, @Spinner_5ValueChanged, true);
            app.Spinner_5.Position = [141 155 100 22];

            % Create Spinner_6
            app.Spinner_6 = uispinner(app.LeftPanel);
            app.Spinner_6.ValueChangedFcn = createCallbackFcn(app, @Spinner_6ValueChanged, true);
            app.Spinner_6.Position = [141 70 100 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create xLabel
            app.xLabel = uilabel(app.RightPanel);
            app.xLabel.Position = [31 482 25 22];
            app.xLabel.Text = 'x';

            % Create yLabel
            app.yLabel = uilabel(app.RightPanel);
            app.yLabel.Position = [31 461 25 22];
            app.yLabel.Text = 'y';

            % Create zLabel
            app.zLabel = uilabel(app.RightPanel);
            app.zLabel.Position = [31 439 25 22];
            app.zLabel.Text = 'z';

            % Create Label
            app.Label = uilabel(app.RightPanel);
            app.Label.Position = [55 482 89 22];
            app.Label.Text = '0';

            % Create Label_2
            app.Label_2 = uilabel(app.RightPanel);
            app.Label_2.Position = [55 460 89 22];
            app.Label_2.Text = '0';

            % Create Label_3
            app.Label_3 = uilabel(app.RightPanel);
            app.Label_3.Position = [55 439 89 22];
            app.Label_3.Text = '0';

            % Create rollLabel
            app.rollLabel = uilabel(app.RightPanel);
            app.rollLabel.Position = [155 483 25 22];
            app.rollLabel.Text = 'roll';

            % Create pitchLabel
            app.pitchLabel = uilabel(app.RightPanel);
            app.pitchLabel.Position = [155 462 31 22];
            app.pitchLabel.Text = 'pitch';

            % Create yawLabel
            app.yawLabel = uilabel(app.RightPanel);
            app.yawLabel.Position = [156 440 27 22];
            app.yawLabel.Text = 'yaw';

            % Create Label_4
            app.Label_4 = uilabel(app.RightPanel);
            app.Label_4.Position = [190 483 79 22];
            app.Label_4.Text = '0';

            % Create Label_5
            app.Label_5 = uilabel(app.RightPanel);
            app.Label_5.Position = [190 461 79 22];
            app.Label_5.Text = '0';

            % Create Label_6
            app.Label_6 = uilabel(app.RightPanel);
            app.Label_6.Position = [190 440 79 22];
            app.Label_6.Text = '0';

            % Create PosicinefectorfinalmLabel
            app.PosicinefectorfinalmLabel = uilabel(app.RightPanel);
            app.PosicinefectorfinalmLabel.Position = [77 515 146 22];
            app.PosicinefectorfinalmLabel.Text = 'Posición efector final (m-°)';

            % Create xLabel_2
            app.xLabel_2 = uilabel(app.RightPanel);
            app.xLabel_2.Position = [632 482 25 22];
            app.xLabel_2.Text = 'x';

            % Create yLabel_2
            app.yLabel_2 = uilabel(app.RightPanel);
            app.yLabel_2.Position = [632 461 25 22];
            app.yLabel_2.Text = 'y';

            % Create zLabel_2
            app.zLabel_2 = uilabel(app.RightPanel);
            app.zLabel_2.Position = [632 439 25 22];
            app.zLabel_2.Text = 'z';

            % Create Label_7
            app.Label_7 = uilabel(app.RightPanel);
            app.Label_7.Position = [656 482 89 22];
            app.Label_7.Text = '0';

            % Create Label_8
            app.Label_8 = uilabel(app.RightPanel);
            app.Label_8.Position = [656 460 89 22];
            app.Label_8.Text = '0';

            % Create Label_9
            app.Label_9 = uilabel(app.RightPanel);
            app.Label_9.Position = [656 439 89 22];
            app.Label_9.Text = '0';

            % Create rollLabel_2
            app.rollLabel_2 = uilabel(app.RightPanel);
            app.rollLabel_2.Position = [756 483 25 22];
            app.rollLabel_2.Text = 'roll';

            % Create pitchLabel_2
            app.pitchLabel_2 = uilabel(app.RightPanel);
            app.pitchLabel_2.Position = [756 462 31 22];
            app.pitchLabel_2.Text = 'pitch';

            % Create yawLabel_2
            app.yawLabel_2 = uilabel(app.RightPanel);
            app.yawLabel_2.Position = [757 440 27 22];
            app.yawLabel_2.Text = 'yaw';

            % Create Label_10
            app.Label_10 = uilabel(app.RightPanel);
            app.Label_10.Position = [791 483 79 22];
            app.Label_10.Text = '0';

            % Create Label_11
            app.Label_11 = uilabel(app.RightPanel);
            app.Label_11.Position = [791 461 79 22];
            app.Label_11.Text = '0';

            % Create Label_12
            app.Label_12 = uilabel(app.RightPanel);
            app.Label_12.Position = [791 440 79 22];
            app.Label_12.Text = '0';

            % Create PosicinefectorfinalmLabel_2
            app.PosicinefectorfinalmLabel_2 = uilabel(app.RightPanel);
            app.PosicinefectorfinalmLabel_2.Position = [678 515 146 22];
            app.PosicinefectorfinalmLabel_2.Text = 'Posición efector final (m-°)';

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.RightPanel);
            title(app.UIAxes3, 'Title')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            app.UIAxes3.Position = [6 6 532 432];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.RightPanel);
            title(app.UIAxes4, 'Title')
            xlabel(app.UIAxes4, 'X')
            ylabel(app.UIAxes4, 'Y')
            app.UIAxes4.Position = [537 6 521 435];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_6_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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