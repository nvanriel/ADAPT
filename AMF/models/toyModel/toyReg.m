function reg = toyReg(model)

t = getTime(model);
p = model.fitParameters;

lab1 = model.options.lab1;

dt = t(end) - t(1);

if t(end) == 0
    reg = 0;
else
    reg = ([p.curr] - [p.prev]) ./ [p.init] ./ dt * lab1;
end