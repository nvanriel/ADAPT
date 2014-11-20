function [pest, sse, resid] = fit(model)

model.time = model.fitTime;
parseAll(model);

p = model.fitParameters;

x0 = [model.states.init];
p0 = [p.init];
lb = [p.lb];
ub = [p.ub];

opt = model.options.optimset;

tic
[pest, sse, resid] = lsqnonlin(@objectiveFunction,(p0),lb,ub,opt, model, x0);
toc

saveTrajectory(model);

function error = objectiveFunction(pest, model, x0)

import AMF.*

t = model.fitTime;

setFitParameters(model, t, pest);

computeAll(model, t, x0, [model.parameters.curr]);

error = getResiduals(model);