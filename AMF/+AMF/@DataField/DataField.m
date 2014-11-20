classdef DataField < AMF.DataComponent
    properties
    end
    methods
        function this = DataField(index, name, obs, timeField, valField, stdField, unitConv, smooth)
            this.index = index;
            this.name = name;
            this.obs = obs;
            this.timeField = timeField;
            this.valField = valField;
            this.stdField = stdField;
            this.unitConv = unitConv;
            this.smooth = smooth;
            
            this.src.val = [];
            this.src.std = [];
            this.src.time = [];
            this.ppform = struct();
            
            this.curr.val = [];
            this.curr.std = [];
        end
    end
end