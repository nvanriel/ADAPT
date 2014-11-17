classdef DataFunction < AMF.DataComponent
    properties
        func
        args
    end
    methods
        function this = DataFunction(index, name, obs, func, args)
            this.index = index;
            this.name = name;
            this.obs = obs;
            this.func = func;
            this.args = args;
        end
    end
end