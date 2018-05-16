function plot_vol_mod(vol,time,xData,desc_str)
    global dateStr;
    global figure_num;
    figure_num = figure_num + 1;
    for channel_num = 1:8
        average_value(channel_num) = mean(vol(:,channel_num));
        std_value(channel_num) = std(vol(:,channel_num));
        min_value(channel_num) = min(vol(:,channel_num));
        max_value(channel_num) = max(vol(:,channel_num));
        pp_value(channel_num) = max_value(channel_num) - min_value(channel_num);
    end
    vol_delta = ceil(max(pp_value) * 100) / 100.0;
    if nargin == 4
        title_str = ['K����ֱ����ջ���ͨ���ĵ�ѹ���ߣ���������:',dateStr,desc_str,'��'];
    else
        title_str = ['K����ֱ����ջ���ͨ���ĵ�ѹ���ߣ���������:',dateStr,'��'];
    end
    channel_num = 0;
    if isdatetime(time(1))
        x_num = datenum(time);
    else
        x_num = time;
    end
    for num = 1:2
        figure('name',[num2str(figure_num + num),'-��ѹ����']);
        for fig_num = 1 : 4
            channel_num = channel_num + 1;
            subplot(2,2,fig_num);
            plot(x_num ,vol(:,channel_num));
            ax = gca;
            ax.XTick = datenum(xData);
            datetick(ax,'x','mm/DD HH:MM','keepticks');
            minValue = floor(min_value(channel_num) * 100) / 100.0;
            maxValue = minValue + vol_delta;
            if minValue == maxValue
                vol_delta = 0.1;
            end
            ylnew = [minValue  maxValue];
            set(gca, 'Ylim', ylnew);
            set(gca,'ytick',minValue:(vol_delta/5):(minValue + vol_delta));
            xlabel('ʱ��/(ʱ:��)');
            ylabel('��ѹ/V');
            title(['ͨ��',num2str(channel_num)]);
            set(gca,'FontSize',14);
            grid on;
            hold on;
        end
        suptitle(title_str);
        set (gcf,'Position',[100,100,1000,800], 'color','w');
        hold off;
        %figure_num = figure_num + 1;
        %save2word([dateStr,'vol_report.doc'],['-f',num2str(figure_num)]);
    end
    K_data_vol = [average_value;std_value;pp_value];
    save('data_vol.mat', 'K_data_vol');
end