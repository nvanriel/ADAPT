function ui = manipulate(model, compName)


import AMF.*

ui = GridUI;

params = getAll(model, 'parameters');
for i = 1:length(params)
    p = params(i);
    ui.draw(p.name, 'EDIT', [i, 1], [1, 6], model.result.pcurr(p.index), {@update, model, compName});
end

ui.draw('ax1', 'AXES', [1, 8], [20, 25], 0, []);

render(ui);
update(ui, model, compName);

function update(ui, model, compName)

import AMF.*

params = getAll(model, 'parameters');
for i = 1:length(params)
    p = params(i);
    model.result.pcurr(p.index) = ui.controls.(p.name).value;
end

result = simulate(model);
cla;
plot(result, compName);