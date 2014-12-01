classdef DataFunction < AMF.DataComponent
    properties
        valExpr
        stdExpr
    end
    methods
        function this = DataFunction(index, name, obs, timeField, valExpr, stdExpr)
            this.index = index;
            this.name = name;
            this.obs = obs;
            this.timeField = timeField;
            this.valExpr = valExpr;
            this.stdExpr = stdExpr;
        end
    end
end