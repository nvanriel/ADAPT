function reg = regFun(model)

if model.options.lab1 > 0
    t = model.time;
    p = model.fitParameters;

    lab1 = model.options.lab1;

    % < standard ADAPT reg
    dt = t(end) - t(1);

    if t(end) == 0
        reg = 0;
    else
        reg = ([p.curr] - [p.prev]) ./ [p.init] ./ dt * lab1;
    end
    % />

else
    reg = 0;
end