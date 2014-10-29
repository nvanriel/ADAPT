function meta = extract_meta_m(R, iters, type, index, temp)
% extract meta data : 
% (median, median absolute difference (mad), median + mad, median - mad)

% extracts meta data from predefined data slice (temp in function arguments)
% or when not provided
% extracts from data at specified 'type' (i.e. 'j', 'x', 'p'), and 'index'

time_steps = length(R(1).x(1,:));
if temp == 0;
    temp = make_temp(R, iters, time_steps, type, index);
end

temp = temp';
meta = zeros(time_steps,4);
for dt = 1:time_steps
    y = quantile(temp(dt,:),[0.05 0.16 0.25 0.5 0.75 0.84 0.95], 2);
    meta(dt,1) = y(4);
    meta(dt,2) = median(abs(temp(dt,:)- meta(dt,1)));
    meta(dt,3) = meta(dt,1)+meta(dt,2);
    meta(dt,4) = meta(dt,1)-meta(dt,2);    
end


