function result = simulate(model)

model.time = getTime(model);
t = model.time;

x0 = [model.states.init];
p = [model.parameters.curr];

result = computeAll(model, t, x0, p);
saveTrajectory(model);