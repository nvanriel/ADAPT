%% initialize

import AMF.*

model = Model('tiemannModel');
data = DataSet('tiemannData');

loadGroup(data, 'oosterveer');
initiateExperiment(model, data);

%% config

model.options.useMex       = 1;
model.options.savePrefix   = '';
model.options.odeTol       = [1e-12 1e-12 100];
model.options.numIter      = 1;
model.options.numTimeSteps = 3;
model.options.parScale     = [2 -2];
model.options.seed         = 1;
model.options.SSTime       = 1000;
model.options.lab1         = .1;
model.options.optimset.Display = 'iter';

parseAll(model);
compileAll(model);

%% run

% model.functions.reg = @tiemannReg;

result = runADAPT(model);


%% plot

plotAll(result, 'parameters', 'traj');
plotAll(result, 'states', 'traj');
plotAll(result, 'reactions', 'traj');