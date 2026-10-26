clc;clearvars;
%%
addpath(genpath("..\O3_Lidar\"));

folder = "..\lidar_data";

dates = datetime("2026-10-01", "InputFormat", "uuuu-MM-dd"):datetime("2026-10-31", "InputFormat", "uuuu-MM-dd"); %[control:datePicker:1c9d]{"position":[9,60]} %[control:datePicker:07d9]{"position":[61,112]}

for i = 1:length(dates) %[output:group:24f52fd8]
   download_lidar_data(dates(i),folder) %[output:73b18ac2]
end %[output:group:24f52fd8]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40}
%---
%[control:datePicker:1c9d]
%   data: {"displayFormat":"dd-MMM-uuuu","label":"dates","run":"Nothing"}
%---
%[control:datePicker:07d9]
%   data: {"displayFormat":"dd-MMM-uuuu","label":"Date picker","run":"Nothing"}
%---
%[output:73b18ac2]
%   data: {"dataType":"text","outputData":{"text":"Success\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\n","truncated":false}}
%---
