classdef DataField < AMF.DataComponent
    properties
%         name
%         obs
%         index
%         
%         timeField
%         valField
%         stdField
%         
%         unitConv
%         smooth
%         
%         source
%         time
%         val
%         std
%         
%         ppform
%         options
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
            
            this.source.val = [];
            this.source.std = [];
            this.source.time = [];
            this.source.ppform = struct();
        end
    end
end