function input_values = extract_input(R, iters, indexes )
%extract input values
time_steps = length(R(1).p(1,:));
nr_inds = length(indexes);

input_values = zeros(nr_inds,time_steps+1,iters); 
for i = 1:iters
    sprintf('i = %d', i);
    for j = 1:nr_inds
        sprintf('j = %d', j);
        input_values(j, 1, i) = R(i).p_initial(j);             % initial parameters 
        input_values(j, 2:end, i) = R(i).p(indexes(j),:);
    end
end

end

