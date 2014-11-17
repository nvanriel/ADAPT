%% initialize

import AMF.*

model = Model('toyModel');
data = DataSet('toyData');

loadGroup(data, 'toy');
initiateExperiment(model, data);

%% config

model.options.useMex       = 1;
model.options.savePrefix   = '';
model.options.odeTol       = [1e-12 1e-12 100];
model.options.numIter      = 20;
model.options.numTimeSteps = 50;
model.options.parScale     = [2 -2];
model.options.seed         = 1;
model.options.SSTime       = 1000;
model.options.lab1         = .1;

parseAll(model);
compileAll(model);

%% run

result = runADAPT(model);


%% plot

plotAll(result, 'parameters', 'traj');
plotAll(result, 'states', 'traj');
