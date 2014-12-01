classdef ModelInput < AMF.ModelComponent
    properties
        type
        func
        predictor
        parameters
        method
        
        initVal
        initTime
        
        args
        pidx
    end
    methods
        function this = ModelInput(index, name, type, args, method, meta)
            this = this@AMF.ModelComponent(index, name, meta);
            
            this.type = type;
            this.args = args;
            this.method = method;
        end
    end
end