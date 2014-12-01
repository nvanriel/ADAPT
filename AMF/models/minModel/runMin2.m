%% initialize

import AMF.*

model = Model('minModel2');
data = DataSet('minData');

loadGroup(data, 't2d_1y');
initiateExperiment(model, data);

%% config

model.options.optimset.Display = 'off';
model.options.useMex = 1;
model.options.numIter = 10;
model.options.numTimeSteps = 100;
model.options.SSTime = 45;
model.options.lab1 = .1;
model.options.randPars = 0;
model.options.randData = 1;

parseAll(model);
compileAll(model);

%% run

% model.functions.reg = @minReg;

result = runADAPT(model);

%% plot
close all;

plot(result, {'CP','I','G','Ir','dGdt','HE','Ra_g','ISR2','Gin'});