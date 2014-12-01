%% initialize

import AMF.*

model = Model('minGlucModel');
data = DataSet('minGlucData');

loadGroup(data, 'ngt_pre');
initiateExperiment(model, data);


%% config

model.options.optimset.Display = 'iter';
model.options.useMex = 1;

parseAll(model);
compileAll(model);

%% run

model.functions.reg = @minGlucReg;

result = fit(model);
result = simulate(model);

%% plot

% manipulate(model, 'G');
figure;plot(result, {'G', 'X', 'dGdt', 'Ra_g', 'Gin'});

getValue(result, 'p3')
getValue(result, 'SI', 1)