classdef ModelState < AMF.ModelComponent
    properties
        derivedODE
        compiledODE
        initExpr
    end
    methods
        function this = ModelState(index, name, init, expr, meta)
            this = this@AMF.ModelComponent(index, name, meta);

            this.expr = expr;
            this.initExpr = init;
            
            if isa(this.initExpr, 'double')
                this.init = init;
            end
        end
    end
end