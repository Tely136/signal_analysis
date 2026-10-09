classdef LoadLidarData < matlab.task.LiveTask
    properties(Access = private, Transient)
        Element_ matlab.ui.control.EditField
        Element_1 matlab.ui.control.EditField
        DropDownLabel matlab.ui.control.Label
        DropDown matlab.ui.control.DropDown
        idSliderLabel matlab.ui.control.Label
        idSlider matlab.ui.control.Slider
        idSliderHelper matlab.ui.control.NumericEditField
        TRSliderLabel matlab.ui.control.Label
        TRSlider matlab.ui.control.Slider
        TRSliderHelper matlab.ui.control.NumericEditField
    end

    properties(Dependent)
        State
        Summary
    end

    methods(Access = protected)
        function setup(task)
            createComponents(task);
        end
    end

    methods
        function createComponents(task)
            grid = uigridlayout(task.LayoutManager);
            grid.RowHeight = repmat({'fit'}, 1, 5);
            grid.ColumnWidth = repmat({'fit'}, 1, 2);

            % Create Element_
            nestedGrid = uigridlayout(grid);
            nestedGrid.Layout.Row = 1;
            nestedGrid.Layout.Column = 1;
            nestedGrid.ColumnWidth = {'1x', 30};
            nestedGrid.RowHeight = {'1x'};
            nestedGrid.ColumnSpacing = 5;
            nestedGrid.RowSpacing = 0;
            nestedGrid.Padding = [0 0 0 0];
            task.Element_ = uieditfield(nestedGrid, 'Value', "C:\Users\tely1\OneDrive\Matlab Onedrive\O3_Lidar\proc_functions");
            task.Element_.UserData.sourceLiveControlData.valueType = "string";
            task.Element_.Layout.Row = 1;
            task.Element_.Layout.Column = 1;
            exploreButton = uibutton(nestedGrid);
            exploreButton.Text = '...';
            exploreButton.Layout.Row = 1;
            exploreButton.Layout.Column = 2;
            exploreButton.ButtonPushedFcn = @(~, ~, ~) task.getDir(task.Element_);

            % Create Element_1
            nestedGrid = uigridlayout(grid);
            nestedGrid.Layout.Row = 2;
            nestedGrid.Layout.Column = 1;
            nestedGrid.ColumnWidth = {'1x', 30};
            nestedGrid.RowHeight = {'1x'};
            nestedGrid.ColumnSpacing = 5;
            nestedGrid.RowSpacing = 0;
            nestedGrid.Padding = [0 0 0 0];
            task.Element_1 = uieditfield(nestedGrid, 'Value', "C:\Users\tely1\Downloads\20260423");
            task.Element_1.UserData.sourceLiveControlData.valueType = "string";
            task.Element_1.Layout.Row = 1;
            task.Element_1.Layout.Column = 1;
            exploreButton = uibutton(nestedGrid);
            exploreButton.Text = '...';
            exploreButton.Layout.Row = 1;
            exploreButton.Layout.Column = 2;
            exploreButton.ButtonPushedFcn = @(~, ~, ~) task.getDir(task.Element_1);

            % Create DropDownLabel
            task.DropDownLabel = uilabel(grid, 'Text', 'Drop down');
            task.DropDownLabel.Layout.Row = 3;
            task.DropDownLabel.Layout.Column = 1;

            % Create DropDown
            task.DropDown = uidropdown(grid);
            task.DropDown.Items = {'Binary' 'Mat'};
            task.DropDown.ItemsData = {"bin" "mat"};
            task.DropDown.Value = "bin";
            task.DropDown.Layout.Row = 3;
            task.DropDown.Layout.Column = 2;

            % Create idSliderLabel
            task.idSliderLabel = uilabel(grid, 'Text', 'id');
            task.idSliderLabel.Layout.Row = 4;
            task.idSliderLabel.Layout.Column = 1;

            % Create idSlider
            nestedGrid = uigridlayout(grid);
            nestedGrid.Layout.Row = 4;
            nestedGrid.Layout.Column = 2;
            nestedGrid.ColumnWidth = {'1x', 40};
            nestedGrid.RowHeight = {'1x'};
            nestedGrid.ColumnSpacing = 5;
            nestedGrid.RowSpacing = 0;
            nestedGrid.Padding = [0 0 0 0];
            task.idSlider = uislider(nestedGrid);
            task.idSlider.Layout.Row = 1;
            task.idSlider.Layout.Column = 1;
            task.idSlider.Limits = [1 61];
            task.idSlider.Value = 1;
            task.idSlider.MajorTicks = [];
            task.idSlider.MinorTicks = [];
            task.idSlider.Step = 1;
            task.idSlider.ValueChangedFcn = @(app, event) set(task.idSliderHelper, 'Value', event.Value);
            task.idSlider.ValueChangingFcn = task.idSlider.ValueChangedFcn;
            task.idSliderHelper = uieditfield(nestedGrid, 'numeric');
            task.idSliderHelper.Limits = task.idSlider.Limits;
            task.idSliderHelper.Value = task.idSlider.Value;
            task.idSliderHelper.Layout.Row = 1;
            task.idSliderHelper.Layout.Column = 2;
            task.idSliderHelper.ValueChangedFcn = @(app, event) set(task.idSlider, 'Value', event.Value);

            % Create TRSliderLabel
            task.TRSliderLabel = uilabel(grid, 'Text', 'TR');
            task.TRSliderLabel.Layout.Row = 5;
            task.TRSliderLabel.Layout.Column = 1;

            % Create TRSlider
            nestedGrid = uigridlayout(grid);
            nestedGrid.Layout.Row = 5;
            nestedGrid.Layout.Column = 2;
            nestedGrid.ColumnWidth = {'1x', 40};
            nestedGrid.RowHeight = {'1x'};
            nestedGrid.ColumnSpacing = 5;
            nestedGrid.RowSpacing = 0;
            nestedGrid.Padding = [0 0 0 0];
            task.TRSlider = uislider(nestedGrid);
            task.TRSlider.Layout.Row = 1;
            task.TRSlider.Layout.Column = 1;
            task.TRSlider.Limits = [1 4];
            task.TRSlider.Value = 1;
            task.TRSlider.MajorTicks = [];
            task.TRSlider.MinorTicks = [];
            task.TRSlider.Step = 1;
            task.TRSlider.ValueChangedFcn = @(app, event) set(task.TRSliderHelper, 'Value', event.Value);
            task.TRSlider.ValueChangingFcn = task.TRSlider.ValueChangedFcn;
            task.TRSliderHelper = uieditfield(nestedGrid, 'numeric');
            task.TRSliderHelper.Limits = task.TRSlider.Limits;
            task.TRSliderHelper.Value = task.TRSlider.Value;
            task.TRSliderHelper.Layout.Row = 1;
            task.TRSliderHelper.Layout.Column = 2;
            task.TRSliderHelper.ValueChangedFcn = @(app, event) set(task.TRSlider, 'Value', event.Value);
        end

        function [code,outputs] = generateCode(task)
            outputs = {};
            codeTemplate = ["addpath(genpath(" + task.extractValue(task.Element_) + "))"
                "dataPath = " + task.extractValue(task.Element_1) + ";"
                ""
                "data_format     = " + task.extractValue(task.DropDown) + ";"
                "prefix = ""ol"";"
                ""
                "[scaled_data,times,configs] = read_lidar_datafiles(dataPath,data_format,prefix);"
                "scaled_data = scaled_data(1:8000,:,1:2,:);"
                ""
                "times = times(:,2);"
                ""
                "num_bins = size(scaled_data,1);"
                "num_files = size(scaled_data,2);"
                "num_devices = size(scaled_data,3);"
                ""
                "dz = 3.75;"
                "h = (dz.*(1:num_bins))';"
                "hkm = h./1000;"
                ""
                "id = " + string(task.idSlider.Value) + ";"
                "TR = " + string(task.TRSlider.Value) + ";"
                ""
                ""
                "td = 270;"
                "data_an = scaled_data(:,:,:,1);"
                "data_pc = scaled_data(:,:,:,2);"
                "data_pc = data_pc./(1-data_pc/td);"
                ""
                "bg_an = mean(data_an(7000:end,:,:),1);"
                "bg_pc = mean(data_pc(7000:end,:,:),1);"
                ""
                "an = data_an - bg_an;"
                "pc = data_pc - bg_pc;"
                ""
                "pc_cnvt = NaN(size(pc));"
                ""
                "for i = 1:num_files"
                "    for j = 1:num_devices"
                "        try"
                "            pc_cnvt(:,i,j) = glue_an_pc(an(:,i,j),pc(:,i,j),3,60);"
                "        catch ME"
                "            disp(['error on file ', num2str(i), ', TR, ', num2str(j)]);"
                "        end"
                "    end"
                "end"
                ""
                "pc_287 = pc_cnvt(:,id,1);"
                "pc_299 = pc_cnvt(:,id,2);"
                "clear ME TR an bg_an bg_pc configs dataPath data_an data_format data_pc dz h hkm i id j num_bins num_devices num_files pc pc_287 pc_299 pc_cnvt prefix scaled_data td times;"];
            code = join(string(codeTemplate), newline);
        end

        function summary = get.Summary(~)
            summary = "";
        end

        function state = get.State(task)
            state = struct;
            state.Element_ = task.Element_.Value;
            state.Element_1 = task.Element_1.Value;
            state.DropDown = task.DropDown.Value;
            state.idSlider = task.idSlider.Value;
            state.TRSlider = task.TRSlider.Value;
        end

        function set.State(task, state)
            task.Element_.Value = state.Element_;
            task.Element_1.Value = state.Element_1;
            task.DropDown.Value = state.DropDown;
            task.idSlider.Value = state.idSlider;
            task.idSliderHelper.Value = state.idSlider;
            task.TRSlider.Value = state.TRSlider;
            task.TRSliderHelper.Value = state.TRSlider;
        end

        function reset(task)
            task.Element_.Value = '"C:\Users\tely1\OneDrive\Matlab Onedrive\O3_Lidar\proc_functions"';
            task.Element_1.Value = '"C:\Users\tely1\Downloads\20260423"';
            task.DropDown.Value = "bin";
            task.idSlider.Value = 1;
            task.idSliderHelper.Value = 1;
            task.TRSlider.Value = 1;
            task.TRSliderHelper.Value = 1;
        end
    end


    methods (Access=private)
        function getDir(~, widget)
            dname = uigetdir;
            if dname
                widget.Value = dname;
            end
        end
    end

    methods(Access = private)
        function out = extractValue(~, widget)
            value = widget.Value;
            type = class(value);

            if isfield(widget.UserData, 'sourceLiveControlData')
                type = widget.UserData.sourceLiveControlData.valueType;
            end

            switch (type)
                case "string"
                    out = append('"', replace(value, '"', '""'), '"');
                case "double"
                    out = string(value);
                case "char"
                    out = append("'", replace(value, "'", "''"), "'");
                otherwise
                    out = value;
            end
        end
    end
end