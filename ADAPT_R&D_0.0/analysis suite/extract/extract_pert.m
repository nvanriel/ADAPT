function meta = extract_pert( box, par_index )
% extract perturbation info
time_steps = 200;
temp = zeros(100, time_steps);
if par_index ~= 0;  
    for i = 1:100;
        for k = 1:length(par_index)
            temp(i,:) = temp(i,:) + box(i,:,par_index(k));
        end
    end
else
    temp = box;
end

temp = temp';
meta = zeros(time_steps,4);
for dt = 1:time_steps
    y = quantile(temp(dt,:),[0.05 0.10 0.25 0.5 0.75 0.90 0.95], 2);
    meta(dt,1) = y(4);
    meta(dt,2) = (y(5)-y(3))/2;
%     meta(dt,3) = y(2);
%     meta(dt,4) = y(6);
    meta(dt,3) = y(3);
    meta(dt,4) = y(5);    
end


end

