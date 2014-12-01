function result = simulate(model)

model.time = getTime(model);
t = model.time;

x0 = model.result.xinit;
p = model.result.pcurr;

if ~isempty(model.inputs)
    uvec = model.result.uvec;
    uvec(model.result.uidx) = model.result.pcurr(model.result.upidx);
    
    model.result.u = computeInputs(model, t, uvec);
else
    uvec = [];
end

model.result.p = p;
model.result.x = computeStates(model, t, x0, p, uvec);
model.result.xcurr = model.result.x;
model.result.v = computeReactions(model, t, model.result.x, p, uvec);
model.result.vcurr = model.result.v;
model.result.time = t;

result = AMF.ModelResult(model, model.result);