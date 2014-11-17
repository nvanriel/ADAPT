classdef ModelConstant < AMF.ModelComponent
    properties
    end
    methods
        function this = ModelConstant(index, name, expr, meta)
            this = this@AMF.ModelComponent(index, name, meta);
            
            this.expr = expr;
        end
    end
end