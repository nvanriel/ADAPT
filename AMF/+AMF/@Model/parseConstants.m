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
            
        case 'double'
            comp.val = comp.expr;
            
    end

end