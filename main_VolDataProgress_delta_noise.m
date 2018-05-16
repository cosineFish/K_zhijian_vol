%����������ܺ��ѹ��ǰ��ʱ�̣��ر������ܣ��ĵ�ѹ�Ĳ�ֵ
clear all;clc;
close all;%�ر�����figure����
[filename,filepath]=uigetfile('*.txt','���ļ�');
complete_file = strcat(filepath,filename);
format_data = '%s %s';%ǰ��������ʱ��
for i = 1:1:16%�м�8����5������8���ǵ�ѹ
    format_data = strcat(format_data,' %f');%ע��formatҪ�пո�
end
%%%%%%%%%���ļ�%%%%%%%
fidin = fopen(complete_file,'r+');
sourceData = textscan(fidin,format_data,...
    'CommentStyle','#');%Delimiter,�ָ���,'Delimiter',' '
%%%%%%%%%�ر��ļ�%%%%%%%%%
fclose(fidin);
dateStrings = strcat(sourceData{1},sourceData{2});%sourceData{1}Ϊ��һ������
time = datetime(dateStrings,'InputFormat','uuuu-MM-ddHH:mm:ss');
for i = 1:8
    K_Vol(:,i) = sourceData{10+i};%��ѹ
end
startDate = sourceData{1}{1};%��һ�����ݵĵ�һ��
endDate = sourceData{1}{end};%��һ�����ݵ����һ��
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
%����������ʱ�ĵ�ѹ��ֵ����
xData = linspace(time_noise_on(1),time_noise_on(end),4);
plot_delta_vol(delta_vol,time_noise_on,xData);
%�ѱ�񱣴浽excel��ע��excel�ļ�̫��190KB���ң����ܵ�������д����ȥ�����
global positionRowNum;
global sheetNum;
sheetNum = FLAG_NOISE_STA.DELTA;
positionRowNum = 0;
desc_str = ',�������ز�ֵ';
saveTableData(desc_str);
system('taskkill /F /IM EXCEL.EXE');
%���������mat�ļ�
delete_mat();
close all;%�ر�����ͼ�񴰿�