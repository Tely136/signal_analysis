classdef loadLidarData < matlab.task.LiveTask
    properties(Access = private, Transient)
        EditField matlab.ui.control.EditField
        EditField1 matlab.ui.control.EditField
        DropDownLabel matlab.ui.control.Label
        DropDown matlab.ui.control.DropDown
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
            grid.RowHeight = repmat({'fit'}, 1, 3);
            grid.ColumnWidth = repmat({'fit'}, 1, 2);

            % Create EditField
            nestedGrid = uigridlayout(grid);
            nestedGrid.Layout.Row = 1;
            nestedGrid.Layout.Column = 1;
            nestedGrid.ColumnWidth = {'1x', 30};
            nestedGrid.RowHeight = {'1x'};
            nestedGrid.ColumnSpacing = 5;
            nestedGrid.RowSpacing = 0;
            nestedGrid.Padding = [0 0 0 0];
            task.EditField = uieditfield(nestedGrid, 'Value', "C:\Users\tely1\OneDrive - The City College of New York\Matlab Onedrive\O3_Lidar\proc_functions");
            task.EditField.UserData.sourceLiveControlData.valueType = "string";
            task.EditField.Layout.Row = 1;
            task.EditField.Layout.Column = 1;
            exploreButton = uibutton(nestedGrid);
            exploreButton.Text = '...';
            exploreButton.Layout.Row = 1;
            exploreButton.Layout.Column = 2;
            exploreButton.ButtonPushedFcn = @(~, ~, ~) task.getDir(task.EditField);

            % Create EditField1
            nestedGrid = uigridlayout(grid);
            nestedGrid.Layout.Row = 2;
            nestedGrid.Layout.Column = 1;
            nestedGrid.ColumnWidth = {'1x', 30};
            nestedGrid.RowHeight = {'1x'};
            nestedGrid.ColumnSpacing = 5;
            nestedGrid.RowSpacing = 0;
            nestedGrid.Padding = [0 0 0 0];
            task.EditField1 = uieditfield(nestedGrid, 'Value', "C:\Users\tely1\Downloads\20260423");
            task.EditField1.UserData.sourceLiveControlData.valueType = "string";
            task.EditField1.Layout.Row = 1;
            task.EditField1.Layout.Column = 1;
            exploreButton = uibutton(nestedGrid);
            exploreButton.Text = '...';
            exploreButton.Layout.Row = 1;
            exploreButton.Layout.Column = 2;
            exploreButton.ButtonPushedFcn = @(~, ~, ~) task.getDir(task.EditField1);

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
        end

        function [code,outputs] = generateCode(task)
            outputs = {'scaled_data', 'hkm'};
            codeTemplate = ["addpath(genpath(" + task.extractValue(task.EditField) + "))"
                "dataPath = " + task.extractValue(task.EditField1) + ";"
                ""
                "data_format     = " + task.extractValue(task.DropDown) + ";"
                "prefix = ""ol"";"
                ""
                "[scaled_data,times,configs] = read_lidar_datafiles(dataPath,data_format,prefix);"
                "scaled_data = scaled_data(1:8000,:,:,:);"
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
                "clear configs dataPath data_format dz h num_bins num_devices num_files prefix times;"];
            code = join(string(codeTemplate), newline);
        end

        function summary = get.Summary(~)
            summary = "";
        end

        function state = get.State(task)
            state = struct;
            state.EditField = task.EditField.Value;
            state.EditField1 = task.EditField1.Value;
            state.DropDown = task.DropDown.Value;
        end

        function set.State(task, state)
            task.EditField.Value = state.EditField;
            task.EditField1.Value = state.EditField1;
            task.DropDown.Value = state.DropDown;
        end

        function reset(task)
            task.EditField.Value = '"C:\Users\tely1\OneDrive - The City College of New York\Matlab Onedrive\O3_Lidar\proc_functions"';
            task.EditField1.Value = '"C:\Users\tely1\Downloads\20260423"';
            task.DropDown.Value = "bin";
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