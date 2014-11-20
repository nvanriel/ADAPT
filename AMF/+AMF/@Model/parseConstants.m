function this = parseConstants(this)

if isempty(this.constants)
    return
end

for comp = this.constants
    
    switch class(comp.expr)
        
        case 'char'
            if isempty(this.dataset)
                error('Can not obtain constant value from dataset.');
            end
            
            comp.val = this.dataset.ref.(comp.expr).src.val(1);
            comp.init = comp.val;
            
        case 'double'
            comp.val = comp.expr;
            comp.init = comp.val;
            
    end
    
    comp.curr = comp.init;
    comp.prev = comp.init;
end