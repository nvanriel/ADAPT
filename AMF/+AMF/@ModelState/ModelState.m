classdef ModelState < AMF.ModelComponent
    properties
        derivedODE
        compiledODE
    end
    methods
        function this = ModelState(index, name, init, expr, meta)
            this = this@AMF.ModelComponent(index, name, meta);

            this.expr = expr;
            
            this.init = init;
            this.curr = init;
            this.val = init;
            this.prev = init;
        end
    end
end