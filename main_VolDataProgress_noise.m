clear all;clc;
close all;%关闭所有figure窗口
[filename,filepath]=uigetfile('*.txt','打开文件');
complete_file = strcat(filepath,filename);
lineNum = 0;timeNum = 0;
format_data = '%s %s';%前两部分是时间
for i = 1:1:16%中间8个是5，后面8个是电压
    format_data = strcat(format_data,' %f');%注意format要有空格
end
%%%%%%%%%打开文件%%%%%%%
fidin = fopen(complete_file,'r+');
sourceData = textscan(fidin,format_data,...
    'CommentStyle','#');%Delimiter,分隔符,'Delimiter',' '
%%%%%%%%%关闭文件%%%%%%%%%
fclose(fidin);
dateStrings = strcat(sourceData{1},sourceData{2});
time = datetime(dateStrings,'InputFormat','uuuu-MM-ddHH:mm:ss');
for i = 1:8
    K_Vol(:,i) = sourceData{10+i};%电压
end
startDate = sourceData{1}{1};
endDate = sourceData{1}{end};
%xData = linspace(time(1),time(lineNum),3);
global FLAG_NOISE_STA;
FLAG_NOISE_STA = struct('ON',0,'OFF',1,'UNSTABLE',-1);
[time_noise_on, vol_noise_on,time_noise_off,vol_noise_off] = processVol(time,K_Vol);
%[time_noise_on, delta_vol ] = processVolDelta(time, K_Vol );
global dateStr;
global xlsFilePath;
if startDate == endDate
    dateStr = startDate;
    xlsFilePath = ['data',startDate,'.xls'];
else
    dateStr = [startDate,'~',endDate];
    xlsFilePath = ['data',startDate,'_',endDate,'.xls'];
end
global figure_num;figure_num = 0;
%画打开噪声管时的电压曲线
desc_str = ',噪声管打开';
xData = linspace(time_noise_on(1),time_noise_on(end),4);
plot_vol_mod(vol_noise_on,time_noise_on,xData,desc_str);
%把表格保存到excel，注意excel文件太大（190KB左右）可能导致数据写不进去的情况
global positionRowNum;
global sheetNum;
sheetNum = FLAG_NOISE_STA.ON;
positionRowNum = 0;
saveTableData(desc_str);
%画关闭噪声管时的电压曲线
desc_str = ',噪声管关闭';
xData = linspace(time_noise_off(1),time_noise_off(end),4);
plot_vol_mod(vol_noise_off,time_noise_off,xData,desc_str);
sheetNum = FLAG_NOISE_STA.OFF;
positionRowNum = 0;
saveTableData(desc_str);
system('taskkill /F /IM EXCEL.EXE');
%清除产生的mat文件
delete_mat();
close all;%关闭所有图像窗口