function [time_noise_on, vol_noise_on,time_noise_off,vol_noise_off ] = processVol(time, vol )
%PROCESSTXT 处理电压，分开关噪声管两种情况
%   开关噪声源时的电压分开保存
    vol_count = length(vol(:,1));
    global FLAG_NOISE_STA;
    %FLAG_NOISE_STA = struct('ON',1,'OFF',2,'UNSTABLE',3);
    flag_noise_status = FLAG_NOISE_STA.OFF;
    num_noise_on = 0;num_noise_off = 0;
    vol_range_min = 5;vol_range_max = 402;
    %flag_noise_status = zeros(1,2);%FLAG_NOISE_STA = struct('ON',0,'OFF',1,'UNSTABLE',-1);
%     for num = 2:vol_count
%         delta_vol = (vol(num,8) - vol(num-1,8)) * 1000;%以毫伏为单位
%         if(abs(delta_vol) > vol_range_min && abs(delta_vol) < vol_range_max)
%             flag_noise_status = FLAG_NOISE_STA.UNSTABLE;%电压变压，未稳定
%         elseif delta_vol > vol_range_max
%             flag_noise_status = FLAG_NOISE_STA.ON;%电压上升，开启噪声管
%         elseif delta_vol < -vol_range_max
%             flag_noise_status = FLAG_NOISE_STA.OFF;%电压下降，关闭噪声管
%         else
%             %变化小，则认为状态不变
%         end    
%         if flag_noise_status == FLAG_NOISE_STA.ON
%             num_noise_on = num_noise_on + 1;
%             time_noise_on(num_noise_on) = datenum(time(num));
%             vol_noise_on(num_noise_on,:) = vol(num,:);
%         elseif flag_noise_status == FLAG_NOISE_STA.OFF
%             num_noise_off = num_noise_off + 1;
%             time_noise_off(num_noise_off) = datenum(time(num));
%             vol_noise_off(num_noise_off,:) = vol(num,:);
%         end
%     end
    delta_vol = (vol(2:end,8) - vol(1:end-1,8)) * 1000;%以毫伏为单位
    %flag_unstable = (abs(delta_vol) > vol_range_min && abs(delta_vol) < vol_range_max);
    %flag_noise_status(flag_unstable) = FLAG_NOISE_STA.UNSTABLE;%电压变压，未稳定
    %time_noise_on = datenum(time(flag_unstable == 1));
    %vol_noise_on(:) = vol(flag_unstable == 1);
    flag_high_vol = ( ( (vol(2:end,8) > 2.6) & (abs(delta_vol) < vol_range_min)) == 1);
    flag_low_vol = (((vol(2:end,8) < 2.4) == 1 & ((abs(delta_vol) < vol_range_min)) == 1));
    flag_noise_on = ((delta_vol > vol_range_max) == 1);
    time_noise_on = datenum(time(flag_noise_on | flag_high_vol));
    vol_noise_on = vol(flag_noise_on | flag_high_vol,:);
    flag_noise_off = ((delta_vol < -vol_range_max) == 1);
    time_noise_off = datenum(time(flag_noise_off | flag_low_vol));
    vol_noise_off = vol(flag_noise_off | flag_low_vol,:);
end

