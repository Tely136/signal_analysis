clc;clearvars;
%%
addpath(genpath("O3_Lidar\"));

folder = "..\lidar_data";

dates = datetime(2022,1,1):datetime(2026,12,31);

for i = 1:length(dates) %[output:group:24f52fd8]
   download_lidar_data(dates(i),folder) %[output:03a51b88]
end %[output:group:24f52fd8]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40}
%---
%[output:03a51b88]
%   data: {"dataType":"text","outputData":{"text":"Success\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\nSuccess\n","truncated":false}}
%---
