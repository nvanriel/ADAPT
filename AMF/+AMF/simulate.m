function result = simulate(model)

t = getTime(model);

x0 = [model.states.init];
p = [model.parameters.curr];

result = computeAll(model, t, x0, p);