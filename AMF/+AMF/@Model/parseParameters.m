function this = parseParameters(this)

for comp = this.parameters
    comp.time = this.time(:);
    comp.val = ones(size(comp.time)) * comp.init;
    
    if isa(comp.expr, 'char')
        sourcePar = this.ref.(comp.expr);
        comp.init = sourcePar.init;
        comp.val = sourcePar.init * ones(size(comp.time));
        comp.curr = sourcePar.init;
        comp.prev = sourcePar.init;
    end
end