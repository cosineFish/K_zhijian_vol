clear all;clc;
close all;%�ر�����figure����
[filename,filepath]=uigetfile('*.txt','���ļ�');
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
for i = 1:1:22%ǰ6����ʱ�䣬�м�8����5������8���ǵ�ѹ
    format_data = strcat(format_data,'%f');
end
while ~feof(fidin)         %�ж��Ƿ�Ϊ�ļ�ĩβ
    tline = fgetl(fidin);         %���ļ�����   
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
            K_Vol(lineNum,i) = sourceData{1,14+i};%��ѹ
        end
    else
            continue;
    end%��Ӧ��Ȧ��if
end%��Ӧwhileѭ��
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
%����������
plot_vol(K_Vol);
%�ѱ�񱣴浽excel��ע��excel�ļ�̫��190KB���ң����ܵ�������д����ȥ�����
global positionRowNum;
positionRowNum = 0;
global sheetNum;
sheetNum = 0;
saveTableData();
system('taskkill /F /IM EXCEL.EXE');
%���������mat�ļ�
delete_mat();
close all;%�ر�����ͼ�񴰿�