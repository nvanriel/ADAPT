function ui = tweak(model, compName)


import AMF.*

ui = GridUI;

params = getAll(model, 'parameters');
for i = 1:length(params)
    p = params(i);
    ui.draw(p.name, 'EDIT', [i, 1], [1, 6], p.curr, {@update, model, compName});
end

typeList = {
    'states'
    'reactions'
    'inputs'
};

% ui.draw('Components', 'LISTBOX', [i+2, 1], [4, 6], typeList, {@updateAll, model});

ui.draw('ax1', 'AXES', [1, 8], [20, 25], 0, []);

render(ui);
update(ui, model, compName);

function updateAll(ui, model)

type = ui.controls.Components.value;

subplot(1,1,1);
plotAll(model, type);

function update(ui, model, compName)

% updateAll(ui, model);

import AMF.*

params = getAll(model, 'parameters');
for i = 1:length(params)
    p = params(i);
    p.curr = ui.controls.(p.name).value;
end

parseInputs(model);

simulate(model);
plot(model, compName);