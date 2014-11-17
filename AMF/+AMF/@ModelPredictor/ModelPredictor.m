classdef ModelPredictor < AMF.ModelComponent
    properties
    end
    methods
        function this = ModelPredictor(index, name, val, meta)
            this = this@AMF.ModelComponent(index, name, meta);

            this.val = val(:);
        end
    end
end