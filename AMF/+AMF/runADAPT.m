function modelResult = runADAPT(model)

import AMF.*

model.time = getTime(model);

seed = model.options.seed;
numIter = model.options.numIter;

% if isempty(model.functions.reg)
%     model.functions.reg = @regFun;
% end

rng('default'); rng(seed);

t = getTime(model);

tic

result = getResult(model);
result.error = 0;

for it = 1:numIter
    randomizeParameters(model);
    randomizeData(model);
    initializeObservables(model);

    parseAll(model);
    
    error = zeros(size(t));
    for ts = 1:length(t)
        setTimeStep(model, ts);
        [~, sse, ~] = fitTimeStep(model, ts);

        error(ts) = sse;
    end

    saveTrajectory(model);
    
    itResult = getResult(model);
    itResult.error = error(:);
    
    result(it) = itResult;
    
    fprintf('Computed trajectory %d [%d]\n', it, max(error));
end

resultStr = sprintf('%s_%s_%d_%d', model.options.savePrefix, model.name, model.options.numIter, model.options.numTimeSteps);
save([model.resultsDir, resultStr], 'result');

modelResult = ModelResult(result);

toc