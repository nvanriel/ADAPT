function this = parseStates(this)

for comp = this.states
    comp.time = this.predictor.val;
    comp.val = zeros(size(comp.time));
    
    if isa(comp.init, 'char')
        compName = comp.init;
        comp.init = this.ref.(compName).init;
        comp.curr = comp.init;
        comp.prev = comp.init;
    end
end