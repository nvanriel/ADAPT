%% initialize

import AMF.*

model = Model('minCPepModel');
data = DataSet('minCPepData');

loadGroup(data, 'ngt_pre');
initiateExperiment(model, data);

%% config

model.options.optimset.Display = 'iter';
model.options.useMex = 1;

parseAll(model);
compileAll(model);

%% run

% model.functions.reg = @minCPepReg;

result = fit(model);
% result = simulate(model);

%% plot
close all;

plot(result, {'CP','ISR2','I','HE','G','IDR'});
% manipulate(model, 'CP');

fprintf('\n');
fprintf('T: %.2f\n', getValue(result, 'T', 1))
fprintf('PHIb: %.2f\n', getValue(result, 'PHIb', 1) * 1e9)
fprintf('PHId: %.2f\n', getValue(result, 'PHId', 1))
fprintf('PHIs: %.2f\n', getValue(result, 'PHIs', 1))

ISR = getValue(result, 'ISR');
IDR = getValue(result, 'IDR');

ISRi = trapz(result.time, ISR);
IDRi = trapz(result.time, IDR);

fprintf('HE: %.2f\n', 1-IDRi/ISRi);
fprintf('\n');