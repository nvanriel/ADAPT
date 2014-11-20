function this = parseStates(this)

for comp = this.states
    comp.time = this.time(:);
    comp.val = zeros(size(comp.time));
    
    if isa(comp.init, 'char')
        dataCompName = comp.init;
        comp.init = this.dataset.ref.(dataCompName).val(1);
        comp.curr = comp.init;
        comp.prev = comp.init;
    end
end