clear all;clc;
close all;%关闭所有figure窗口
[filename,filepath]=uigetfile('*.txt','打开文件');
complete_file = strcat(filepath,filename);
fidin = fopen(complete_file,'r+');
lineNum = 0;timeNum = 0;
fileStruct = dir(complete_file);
sizeofFile = fileStruct.bytes;
if sizeofFile > 1024 * 6000
    splitNum = ceil(sizeofFile/102);
elseif sizeofFile > 1024 * 1000
    splitNum = ceil(sizeofFile/364);
else%if sizeofFile > 1024 * 400
    splitNum = ceil(sizeofFile/400);
end
format_data = '';
for i = 1:1:22%前6个是时间，中间8个是5，后面8个是电压
    format_data = strcat(format_data,'%f');
end
while ~feof(fidin)         %判断是否为文件末尾
    tline = fgetl(fidin);         %从文件读行   
    tline = strtrim(tline);
    if isempty(tline)
        continue;
    end
    if ~contains(tline,'#')
        tline = strrep(strrep(tline , ':', ' '),'-',' ');
        lineNum = lineNum + 1;
        sourceData = textscan(tline , format_data);
        if mod(lineNum,splitNum)==1
            timeNum = timeNum + 1;
            hour(timeNum) = sourceData{1,4};
            minute(timeNum) = sourceData{1,5}; 
            second(timeNum) = sourceData{1,6};
        end
        if lineNum == 1
            year = 2018;%year = sourceData{1,1};
            month = sourceData{1,2};
            day = sourceData{1,3};
        end
        for i = 1:8
            K_Vol(lineNum,i) = sourceData{1,14+i};%电压
        end
    else
            continue;
    end%对应外圈的if
end%对应while循环
fclose(fidin);
save('checkdata_num.mat','lineNum', 'splitNum', 'timeNum');
global dateStr;
dateStr = [num2str(year,'%02d'),num2str(month,'%02d'),num2str(day,'%02d')];
global xlsFilePath;
xlsFilePath = ['brt_delta_',num2str(year,'%02d'),num2str(month,'%02d'),'.xls'];
for i = 1:timeNum
    xlabel_vol_str = [num2str(hour(i),'%02d'),':',num2str(minute(i),'%02d')];
    xticklabel{i} = xlabel_vol_str;
end
save checkdata_xtick.mat xticklabel% xlabel_noise_time
%global figure_num;figure_num = 0;
%画亮温曲线
plot_vol(K_Vol);
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