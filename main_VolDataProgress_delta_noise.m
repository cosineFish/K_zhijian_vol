%计算打开噪声管后电压与前面时刻（关闭噪声管）的电压的差值
clear all;clc;
close all;%关闭所有figure窗口
[filename,filepath]=uigetfile('*.txt','打开文件');
complete_file = strcat(filepath,filename);
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
dateStrings = strcat(sourceData{1},sourceData{2});%sourceData{1}为第一列数据
time = datetime(dateStrings,'InputFormat','uuuu-MM-ddHH:mm:ss');
for i = 1:8
    K_Vol(:,i) = sourceData{10+i};%电压
end
startDate = sourceData{1}{1};%第一列数据的第一个
endDate = sourceData{1}{end};%第一列数据的最后一个
global FLAG_NOISE_STA;
FLAG_NOISE_STA = struct('ON',0,'OFF',1,'UNSTABLE',-1,'DELTA',2);
[time_noise_on, delta_vol ] = processVolDelta(time, K_Vol );
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
%画打开噪声管时的电压差值曲线
xData = linspace(time_noise_on(1),time_noise_on(end),4);
plot_delta_vol(delta_vol,time_noise_on,xData);
%把表格保存到excel，注意excel文件太大（190KB左右）可能导致数据写不进去的情况
global positionRowNum;
global sheetNum;
sheetNum = FLAG_NOISE_STA.DELTA;
positionRowNum = 0;
desc_str = ',噪声开关差值';
saveTableData(desc_str);
system('taskkill /F /IM EXCEL.EXE');
%清除产生的mat文件
delete_mat();
close all;%关闭所有图像窗口