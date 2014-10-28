function mean_of_pars = mop(R, iters, time_index)
%get mean of parameter over iterations
mean_of_pars = zeros(length(R(1).p(:,1)),1);
for i = 1:iters
    mean_of_pars(:) = mean_of_pars + R(i).p(:, time_index);
end

mean_of_pars = mean_of_pars/iters;
end

