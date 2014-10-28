function fig_raw(time, var, var_raw, raw_time_points)
% create figure of raw data as errorbars plotted over simulations 
% as area between median and the median absolute differences
X = [time fliplr(time)];
Yupp = var(:,3)';
Ylow = var(:,4)';
Y = [Ylow fliplr(Yupp)];
fill(X,Y, [0.45 0.45 0.45]) % grey
plot(time, var(:,1), '-k', 'LineWidth', 2);
errorbar(gca, raw_time_points, var_raw.m, var_raw.sd, 'k.', 'LineWidth', 2);
var_name = strrep(inputname(2), '_', ' ');
legend(var_name)
xlabel('Time (hours)')
ylabel([var_name  ' (\mumol)'])
end

