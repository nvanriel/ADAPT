classdef DataFunction < AMF.DataComponent
    properties
        func
        args
        stdDataField
    end
    methods
        function this = DataFunction(index, name, obs, func, args, stdDataField)
            this.index = index;
            this.name = name;
            this.obs = obs;
            this.func = func;
            this.args = args;
            this.stdDataField = stdDataField;
        end
    end
end