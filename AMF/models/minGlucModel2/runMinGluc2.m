%% initialize

import AMF.*

model = Model('minGlucModel2');
data = DataSet('minGlucData2');

loadGroup(data, 'ngt_pre');
initiateExperiment(model, data);


%% config

model.options.optimset.Display = 'off';
model.options.useMex = 1;
model.options.numIter = 500;
model.options.numTimeSteps = 100;
model.options.SSTime = 30;
model.options.lab1 = .1;
model.options.randPars = 0;
model.options.randData = 1;

parseAll(model);
compileAll(model);

%% run

% model.functions.reg = @minGlucReg;

result = runADAPT(model);

%% plot
close all

figure;plot(result, {'G', 'dGdt', 'Ra_g', 'Gin'}, 'hist');