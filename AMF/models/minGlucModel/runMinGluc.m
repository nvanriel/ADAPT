%% initialize

import AMF.*

model = Model('minGlucModel');
data = DataSet('minGlucData');

loadGroup(data, 't2d_pre');
initiateExperiment(model, data);


%% config

model.options.optimset.Display = 'iter';
model.options.useMex = 1;

model.functions.reg = @minGlucReg;

parseAll(model);
compileAll(model);

%% run

fit(model);

%% plot

manipulate(model, 'Glucose');

model.ref.SI.val(1)