function meta = extract_meta(R, iters, type, index)
%extract meta data
time_steps = length(R(1).x(1,:));
temp = zeros(iters,time_steps);

if length(index) == 1
    for i = 1:iters
        temp(i,:) = R(i).(type)(index,:);
    end
else 
    for i = 1:iters
        for j = 1:length(index)
            temp(i,:) = temp(i,:) + R(i).(type)(index(j),:);
        end
    end
end
    
temp = temp';
meta = zeros(time_steps,4);
for dt = 1:time_steps
    meta(dt,1) = mean(temp(dt,:));
    meta(dt,2) = std(temp(dt,:))./sqrt(iters);
    meta(dt,3) = meta(dt,1)+2*meta(dt,2);
    meta(dt,4) = meta(dt,1)-2*meta(dt,2);
end


