function this = parseFunctions(this)

import AMF.functions.*

for dataFunc = this.functions
    inputFields = cellfun(@(name) this.ref.(name), dataFunc.args, 'UniformOutput', false);
    [sourceVal, sourceStd, val, std] = dataFunc.func(inputFields{:});
    dataFunc.source.time = inputFields{1}.source.time;
    dataFunc.time = inputFields{1}.time;
    dataFunc.val = val;
    dataFunc.std = std;
    dataFunc.source.val = sourceVal;
    dataFunc.source.std = sourceStd;
end