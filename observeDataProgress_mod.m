clear all;clc;
close all;%关闭所有figure窗口
[filename,filepath]=uigetfile('*.txt','打开文件');
complete_file = strcat(filepath,filename);
fidin = fopen(complete_file,'r+');
lineNum = 0;timeNum = 0;
format_data = '%s%s';%前两部分是时间
for i = 1:1:16%中间8个是5，后面8个是电压
    format_data = strcat(format_data,'%f');
end
while ~feof(fidin)         %判断是否为文件末尾
    tline = fgetl(fidin);         %从文件读行   
    tline = strtrim(tline);
    if isempty(tline)
        continue;
    end
    if ~contains(tline,'#')
        lineNum = lineNum + 1;
        sourceData = textscan(tline , format_data);
        if lineNum == 1
            startDate = sourceData{1,1};
        end
        dateStrings = strcat(sourceData{1,1},sourceData{1,2});
        time(lineNum) = datetime(dateStrings,'InputFormat','uuuu-MM-ddHH:mm:ss');
        for i = 1:8
            K_Vol(lineNum,i) = sourceData{1,10+i};%电压
        end
    else
            continue;
    end%对应外圈的if
end%对应while循环
fclose(fidin);
endDate = sourceData{1,1};
xData = linspace(time(1),time(lineNum),3);
global dateStr;
dateStr = [startDate{1},'~',endDate{1}];
global xlsFilePath;
xlsFilePath = ['data',startDate{1},'_',endDate{1},'.xls'];
%画亮温曲线
plot_vol_mod(K_Vol,time,xData);
%把表格保存到excel，注意excel文件太大（190KB左右）可能导致数据写不进去的情况
global positionRowNum;
positionRowNum = 0;
global sheetNum;
sheetNum = 0;
saveTableData();
system('taskkill /F /IM EXCEL.EXE');
%清除产生的mat文件
delete_mat();
close all;%关闭所有图像窗口