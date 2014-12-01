function result = runADAPT(model)

import AMF.*

model.time = getTime(model);
t = model.time;

seed = model.options.seed;
numIter = model.options.numIter;

rng('default'); rng(seed);

% interpolate data (not randomized)

[idd, ids] = getInterpData(model.dataset, t);
model.result.idd = idd;
model.result.ids = ids;

% pre-allocate
model.result.p = zeros(length(t), length(model.parameters));
model.result.x = zeros(length(t), length(model.states));
model.result.u = zeros(length(t), length(model.inputs));
model.result.v = zeros(length(t), length(model.reactions));
model.result.sse = zeros(length(t), 1);
model.result.time = t;

result = model.result;

tic
parfor it = 1:numIter
    model2 = model; % parfor fix
    elt = 0;
    
    success = 0;
    while ~success
        try
            if model.options.randPars, randomizeParameters(model2); end
            if model.options.randData, randomizeData(model2); end

            parseAll(model2);

            tic
            for ts = 1:length(t)
                fitTimeStep(model2, ts);
            end
            elt = toc;
            
            success = 1;
        catch err
            %
        end
    end

    fprintf('Computed trajectory %d [%d] - %.2fs\n', it, max(model2.result.sse), elt);
    
    result(it) = model2.result;
end
toc

result = AMF.ModelResult(model, result);

resultStr = sprintf('%s_%s_%s__%d_%d', model.options.savePrefix, model.name, model.dataset.activeGroup, model.options.numIter, model.options.numTimeSteps);
save([model.resultsDir, resultStr], 'result');