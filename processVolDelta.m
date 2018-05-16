function [time_noise_on, delta_vol_noise ] = processVolDelta(time, vol )
%PROCESSTXT 计算开关噪声管的电压差值
    %global FLAG_NOISE_STA;
    vol_range_min = 5;vol_range_max = 402;
    %FLAG_NOISE_STA = struct('ON',0,'OFF',1,'UNSTABLE',-1);
    delta_vol = (vol(2:end,8) - vol(1:end-1,8)) * 1000;%以毫伏为单位
    flag_high_vol = ( ( (vol(2:end,8) > 2.6) & (abs(delta_vol) < vol_range_min)) == 1);
    flag_low_vol = (((vol(2:end,8) < 2.4) == 1 & ((abs(delta_vol) < vol_range_min)) == 1));
    %开噪声
    flag_vol_up = ((delta_vol > vol_range_max) == 1);
    flag_noise_on = flag_vol_up | flag_high_vol;
    time_noise_on = datenum(time(flag_noise_on));
    %vol_noise_on = vol(flag_noise_on,:);
    %关噪声
    flag_vol_down = ((delta_vol < -vol_range_max) == 1);
    flag_noise_off = flag_vol_down | flag_low_vol;
    %time_noise_off = datenum(time(flag_noise_off));
    %vol_noise_off = vol(flag_noise_off,:);
    flag_last_low_vol = ((flag_noise_off(1:end-1)==1) & (flag_noise_off(2:end)==0));
    last_low_vol = vol(flag_last_low_vol,1:8);
    start_index_high_vol = find((flag_noise_on(1:end-1)==0) & (flag_noise_on(2:end)==1)) + 1;%从低电压到高电压
    end_index_high_vol = find((flag_noise_on(1:end-1)==1) & (flag_noise_on(2:end) == 0));%从高电压到低电压
    delta_index_high_vol = end_index_high_vol - start_index_high_vol;
    delta_start_index = 1;
    for i = 1:length(last_low_vol)
        delta_end_index = delta_start_index + delta_index_high_vol(i);
        delta_vol_noise(delta_start_index:delta_end_index,1:8) = ...
            vol(start_index_high_vol(i):end_index_high_vol(i),1:8) - last_low_vol(i,1:8);
        delta_start_index = delta_end_index + 1;
    end
end

