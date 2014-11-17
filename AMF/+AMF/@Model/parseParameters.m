function this = parseParameters(this)

for comp = this.parameters
    comp.time = this.predictor.val;
    comp.val = ones(size(comp.time)) * comp.init;
end