function saveTableData(desc_str)
    global xlsFilePath;
    global dateStr;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�������ݱ��
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('data_vol.mat', 'K_data_vol');
    for i = 1:8
        cnames(i) = {['ͨ��',num2str(i)]};
    end
    global rnames;
    rnames = {'��ֵ/V','��׼��/V','���ֵ/V'};
    if nargin == 1
        title = ['Kֱ����ջ���ѹ(��������:',dateStr,desc_str,'��'];
    elseif nargin == 0
        title = ['Kֱ����ջ���ѹ(��������:',dateStr,'��'];
    end
    write2xls(xlsFilePath,title,cnames,K_data_vol,length(cnames)); 
end