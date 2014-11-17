%%

import AMF.*

data = DataSet('minGlucData');

%%

for i = 1:length(data.groups)
    loadGroup(data, data.groups{i});
    
    model = Model('minGlucModel');

    model.options.optimset.Display = 'iter';
    model.options.useMex = 1;

    model.functions.reg = @minGlucReg;
    
    initiateExperiment(model, data);

    parseAll(model);
    compileAll(model);

    fit(model);
    
    result.(data.groups{i}) = ModelResult(getResult(model));
end

%% plot

% manipulate(model, 'Glucose');
% 
% model.ref.SI.val(1)