function result = fit(model)

import AMF.*

model.time = getFitTime(model.dataset);
t = model.time;
model.result.time = t;

model.result.pidx = logical([model.parameters.fit]);
model.result.pcurr = [model.parameters.init];

lb = [model.fitParameters.lb];
ub = [model.fitParameters.ub];

p0 = [model.fitParameters.init];
x0 = [model.states.init];

tic
[~, sse, ~] = lsqnonlin(@objectiveFunction,(p0),lb,ub,model.options.optimset, model,t,x0);
toc

model.result.p = model.result.pcurr;
model.result.x = model.result.xcurr;
model.result.v = model.result.vcurr;
model.result.sse = sse;

if ~isempty(model.inputs)
    uvec = model.result.uvec;
    uvec(model.result.uidx) = model.result.pcurr(model.result.upidx);
    
    model.result.u = computeInputs(model, t, uvec);
end

result = ModelResult(model, model.result);

function error = objectiveFunction(pest, model, t, x0)

model.result.pcurr(model.result.pidx) = pest;
p = model.result.pcurr;

uvec = model.result.uvec;
uvec(model.result.uidx) = model.result.pcurr(model.result.upidx);

x = computeStates(model, t, x0, p, uvec);
v = computeReactions(model, t, x, p, uvec);

model.result.xcurr = x;
model.result.vcurr = v;

ox = x(:,model.result.oxi);
of = v(:,model.result.ofi);

sim = [ox of];

odi = [model.result.oxdi model.result.ofdi];

dat = model.result.dd(:,odi);
sd = model.result.ds(:,odi);

error = (sim(:) - dat(:)) ./ sd(:);

error = [error;zeros(length(p), 1)];

if ~isempty(model.functions.reg)
    error = [error; model.functions.reg(model, model.iStruct, model.dStruct)];
end

error = error(~isnan(error));
error = error(~isinf(error));