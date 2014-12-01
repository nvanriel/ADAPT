function [pest, sse, resid] = fitTimeStep(model, ts)

setTimeStep(model, ts);

model.result.pprev = model.result.pcurr;

x0 = model.result.xcurr;
p0 = model.result.pcurr(model.result.pidx);
lb = model.result.lb(model.result.pidx);
ub = model.result.ub(model.result.pidx);

t = getTime(model, ts);

[pest, sse, resid] = lsqnonlin(@objectiveFunction,(p0),lb,ub,model.options.optimset, model,x0,t,ts);

model.result.p(ts,:) = model.result.pcurr;
model.result.x(ts,:) = model.result.xcurr;
model.result.v(ts,:) = model.result.vcurr;
model.result.sse(ts) = sse;

if ~isempty(model.inputs)
    uvec = model.result.uvec;
    uvec(model.result.uidx) = model.result.pcurr(model.result.upidx);
    
    model.result.u(ts,:) = computeInputs(model, t(end), uvec);
end

function error = objectiveFunction(pest, model, x0, t, ts)

model.result.pcurr(model.result.pidx) = pest;
p = model.result.pcurr;

uvec = model.result.uvec;
uvec(model.result.uidx) = model.result.pcurr(model.result.upidx);

x = computeStates(model, t, x0, p, uvec);
v = computeReactions(model, t(end), x(end,:), p, uvec);

model.result.xcurr = x(end,:);
model.result.vcurr = v;

ox = model.result.xcurr(model.result.oxi);
of = model.result.vcurr(model.result.ofi);

sim = [ox of];

odi = [model.result.oxdi model.result.ofdi];

dat = model.result.idd(ts,odi);
sd = model.result.ids(ts,odi);

error = (sim(:) - dat(:)) ./ sd(:);

error = [error;zeros(length(p), 1)];

reg = AMF.regFun(model, t);
error = [error;reg(:)];

if ~isempty(model.functions.reg)
    error = [error; model.functions.reg(model, model.iStruct, model.dStruct)];
end

error(isnan(error)) = 0;
error(isinf(error)) = 0;