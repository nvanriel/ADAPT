%% initialize

import AMF.*

model = Model('minCPepModel2');
data = DataSet('minCPepData');

loadGroup(data, 't2d_3mo');
initiateExperiment(model, data);

%% config

model.options.optimset.Display = 'off';
model.options.useMex = 1;
model.options.numIter = 1;
model.options.numTimeSteps = 20;
model.options.SStime = 30;
model.options.seed = 2;
model.options.randPars = 0;
model.options.randData = 0;

parseAll(model);
compileAll(model);

%% run

% model.functions.reg = @minCPepReg;

result = runADAPT(model);

%% plot
close all;

plot(result, {'CP','CP1','I','HE','G','dGdt','pdGdt','SRd','SRs'});

% pdGdt haywire - standard deviations too big (will be better if calculated
% using propagation of uncertainty. Will be fixed in combined minModel (no
% inputs just states).