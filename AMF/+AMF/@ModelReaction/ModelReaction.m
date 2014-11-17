classdef ModelReaction < AMF.ModelComponent
    properties
    end
    methods
        function this = ModelReaction(index, name, expr, meta)
            this = this@AMF.ModelComponent(index, name, meta);
            
            this.expr = expr;
        end
    end
end