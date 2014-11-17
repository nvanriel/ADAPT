classdef ModelParameter < AMF.ModelComponent
    properties
        fit
        lb
        ub
    end
    methods
        function this = ModelParameter(index, name, fit, init, bnd, meta)
            this = this@AMF.ModelComponent(index, name, meta);

            this.init = init;
            this.val = init;
            this.curr = init;
            this.prev = init;
            
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