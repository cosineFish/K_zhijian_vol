function plot_vol(vol)
    load checkdata_xtick.mat xticklabel
    load('checkdata_num.mat','lineNum', 'splitNum', 'timeNum');
    global dateStr;%global figure_num;
    for channel_num = 1:8
        average_value(channel_num) = mean(vol(:,channel_num));
        std_value(channel_num) = std(vol(:,channel_num));
        min_value(channel_num) = min(vol(:,channel_num));
        max_value(channel_num) = max(vol(:,channel_num));
        pp_value(channel_num) = max_value(channel_num) - min_value(channel_num);
    end
    vol_delta = ceil(max(pp_value) * 100) / 100.0;
    channel_num = 0;
    for num = 1:2
        figure('name',[num2str(num),'-电压曲线']);
        for fig_num = 1 : 4
            channel_num = channel_num + 1;
            subplot(2,2,fig_num);
            plot(1:1:lineNum ,vol(:,channel_num));
            set(gca,'xtick',1:splitNum:timeNum*splitNum +1);
            set(gca,'xticklabel',xticklabel);
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
        suptitle(['K波段直检接收机各通道的电压曲线（测量日期:',dateStr,'）']);
        set (gcf,'Position',[100,100,1000,800], 'color','w');
        hold off;
        %figure_num = figure_num + 1;
        %save2word([dateStr,'vol_report.doc'],['-f',num2str(figure_num)]);
    end
    K_data_vol = [average_value;std_value;pp_value];
    save('data_vol.mat', 'K_data_vol');
end