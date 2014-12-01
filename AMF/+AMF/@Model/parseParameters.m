function this = parseParameters(this)

for comp = this.parameters
    
    if isa(comp.expr, 'char')
        sourcePar = this.ref.(comp.expr);
        comp.init = sourcePar.init;
    end
end

this.result.pcurr = [this.parameters.init];
this.result.pinit = [this.parameters.init];
this.result.pidx = logical([this.parameters.fit]);
this.result.lb = [this.parameters.lb];
this.result.ub = [this.parameters.ub];