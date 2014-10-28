function temp = make_temp(R, iters, time_steps, type, index)
% take a slice of the needed results for creating meta data
temp = zeros(iters, time_steps);
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

end

