function [pest, sse, resid] = fitTimeStep(model, ts)

p = model.fitParameters;

if ts > 1
    x0 = [model.states.curr];
    p0 = [p.curr];
    
    [model.states.prev] = model.states.curr;
    [model.reactions.prev] = model.reactions.curr;
    [model.parameters.prev] = model.parameters.curr;
else
    x0 = [model.states.init];
    p0 = [p.init];
end

lb = [p.lb];
ub = [p.ub];

opt = model.options.optimset;

[pest, sse, resid] = lsqnonlin(@objectiveFunction,(p0),lb,ub,opt, model,x0,ts);

function error = objectiveFunction(pest, model, x0, ts)

import AMF.*

t = getTime(model, ts);

setFitParameters(model, t, pest, ts);
computeAll(model, t, x0, [model.parameters.curr], ts);

error = getResiduals(model, ts);