function [Tz, Tm, Te] = zme(SensBox, names_par, names_xj)
% Obtain mean sensitivity indexes (across all iterations) at time = 0, time
% = end and time = inbetween. Then writes the information to xls format.

% names_xj = names_xj(1:(end-6));
% orienting the matrix-scape
iters = length(SensBox(:,1,1,1));
time_z = 1;
time_e = length(SensBox(1,:,1,1));
time_m = floor(time_e/2);


% taking means of iters for specified time points
coefs_z = zeros(length(names_par),length(names_xj));
coefs_m = zeros(length(names_par),length(names_xj));
coefs_e = zeros(length(names_par),length(names_xj));

for i = 1: length(names_par)
    coefs_z(i,:) =  mean(SensBox(:,time_z,i,:));
    coefs_m(i,:) =  mean(SensBox(:,time_m,i,:));
    coefs_e(i,:) =  mean(SensBox(:,time_e,i,:));
end



Tz = array2table(coefs_z, 'RowNames', names_par, 'VariableNames', names_xj);
Tm = array2table(coefs_m, 'RowNames', names_par, 'VariableNames', names_xj);
Te = array2table(coefs_e, 'RowNames', names_par, 'VariableNames', names_xj);

writetable(Tz, 'coefs.xls', 'Sheet', 1, 'WriteVariableNames', 1, 'WriteRowNames', 1);
writetable(Tm, 'coefs.xls', 'Sheet', 2, 'WriteVariableNames', 1, 'WriteRowNames', 1);
writetable(Te, 'coefs.xls', 'Sheet', 3, 'WriteVariableNames', 1, 'WriteRowNames', 1);
end

