function saveTableData(desc_str)
    global xlsFilePath;
    global dateStr;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %保存数据表格
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    load('data_vol.mat', 'K_data_vol');
    for i = 1:8
        cnames(i) = {['通道',num2str(i)]};
    end
    global rnames;
    rnames = {'均值/V','标准差/V','峰峰值/V'};
    if nargin == 1
        title = ['K直检接收机电压(测量日期:',dateStr,desc_str,'）'];
    elseif nargin == 0
        title = ['K直检接收机电压(测量日期:',dateStr,'）'];
    end
    write2xls(xlsFilePath,title,cnames,K_data_vol,length(cnames)); 
end