function plot_delta_vol(vol,time,xData,desc_str)
    global dateStr;
    global figure_num;
    figure_num = figure_num + 1;
    average_value(1:8) = mean(vol(:,1:8));
    std_value(1:8) = std(vol(:,1:8));
    min_value(1:8) = min(vol(:,1:8));
    max_value(1:8) = max(vol(:,1:8));
    pp_value(1:8) = max_value(1:8) - min_value(1:8);
    vol_delta = ceil(max(pp_value) * 100) / 100.0;
    if nargin == 4
        title_str = ['K波段直检接收机各通道的电压差值曲线（测量日期:',dateStr,desc_str,'）'];
    else
        title_str = ['K波段直检接收机各通道的电压差值曲线（测量日期:',dateStr,'）'];
    end
    channel_num = 0;
    if isdatetime(time(1))
        x_num = datenum(time);
    else
        x_num = time;
    end
    for num = 1:2
        figure('name',[num2str(figure_num + num),'-电压曲线']);
        for fig_num = 1 : 4
            channel_num = channel_num + 1;
            subplot(2,2,fig_num);
            plot(x_num ,vol(1:length(x_num),channel_num));
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
            xlabel('时间/(时:分)');
            ylabel('电压/V');
            title(['通道',num2str(channel_num)]);
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