function reg = regFun(model, t)

lab1 = model.options.lab1;
pcurr = model.result.pcurr;
pprev = model.result.pprev;
pinit = model.result.pinit;

dt = t(end) - t(1);

if t(end) == 0
    reg = zeros(1, length(pcurr));
else
    reg = (pcurr - pprev) ./ pinit ./ dt * lab1;
end