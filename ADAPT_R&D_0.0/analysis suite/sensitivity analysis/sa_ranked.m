function sar = sa_ranked( SensBox, names_par, names_xj )
%rank the control coefficients over iterations over time

iters = length(SensBox(:,1,1,1));
time = length(SensBox(1,:,1,1));

% taking mean of iters for every time point
coefs = zeros(time, length(names_par),length(names_xj));
coefs_ot = zeros(length(names_par),length(names_xj));
for time_i = 1:time
    for i = 1: length(names_par)
        coefs(time_i,i,:) =  mean(SensBox(:,time_i,i,:));
    end
end

% taking mean over time for all parameters
for i = 1:length(names_par)
    coefs_ot(i,:) = mean(coefs(:,i,:));
end

% write to table
if verLessThan('matlab', '8.1.0')
    sa_dataset = dataset({coefs_ot, names_xj{:}}, 'ObsNames', names_par);
    export(sa_dataset, 'XLSfile', 'sensitivity_analysis');
else
    sar = array2table(coefs_ot, 'RowNames', names_par, 'VariableNames', names_xj);
    writetable(sar, 'sensitivity_analysis.xls', 'Sheet', 1, 'WriteVariableNames', 1, 'WriteRowNames', 1);
end

end


