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
model.options.numTimeSteps = 100;
model.options.parScale     = [2 -2];
model.options.seed         = 1;
model.options.SSTime       = 1000;
model.options.lab1         = .1;
model.options.optimset.Display = 'off';

parseAll(model);
compileAll(model);

%% run

result = runADAPT(model);
% result = simulate(model);

%% plot
close all

plot(result, {'s3','ds3dt','k1'});

% plotAll(result, 'states', 'traj');
% plotAll(result, 'parameters', 'traj');

% v1 = getValue(result, 'v1');
% v2 = getValue(result, 'v2');
% s3 = getValue(result, 's3');
% t = result.time;
% 
% figure;plot(diff(s3)./repmat(diff(t(:)),1,size(s3,2)), 'r');hold on;plot(v1-v2, 'b');