clear all;clc;
close all;%�ر�����figure����
[filename,filepath]=uigetfile('*.txt','���ļ�');
complete_file = strcat(filepath,filename);
fidin = fopen(complete_file,'r+');
lineNum = 0;timeNum = 0;
format_data = '%s%s';%ǰ��������ʱ��
for i = 1:1:16%�м�8����5������8���ǵ�ѹ
    format_data = strcat(format_data,'%f');
end
while ~feof(fidin)         %�ж��Ƿ�Ϊ�ļ�ĩβ
    tline = fgetl(fidin);         %���ļ�����   
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
            K_Vol(lineNum,i) = sourceData{1,10+i};%��ѹ
        end
    else
            continue;
    end%��Ӧ��Ȧ��if
end%��Ӧwhileѭ��
fclose(fidin);
endDate = sourceData{1,1};
xData = linspace(time(1),time(lineNum),3);
global dateStr;
dateStr = [startDate{1},'~',endDate{1}];
global xlsFilePath;
xlsFilePath = ['data',startDate{1},'_',endDate{1},'.xls'];
%����������
plot_vol_mod(K_Vol,time,xData);
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