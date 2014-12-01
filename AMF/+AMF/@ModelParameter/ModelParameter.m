classdef ModelParameter < AMF.ModelComponent
    properties
        fit
        lb
        ub
    end
    methods
        function this = ModelParameter(index, name, fit, expr, bnd, meta)
            this = this@AMF.ModelComponent(index, name, meta);

            this.expr = expr;
            if isa(expr, 'double')
                this.init = expr;
            end
            
            this.fit = fit;
            
            if isempty(bnd)
                this.lb = 0;
                this.ub = inf;
            else
                this.lb = bnd(1);
                this.ub = bnd(2);
            end
        end
    end
end