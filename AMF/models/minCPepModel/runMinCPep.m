%% initialize

import AMF.*

model = Model('minCPepModel');
data = DataSet('minCPepData');

loadGroup(data, 'ngt_3mo');
initiateExperiment(model, data);

%% config

model.options.optimset.Display = 'off';
model.options.useMex = 1;

parseAll(model);
compileAll(model);

%% run

fit(model);

%% plot

manipulate(model, 'c1');