classdef ModelComponent < handle
    properties
        index
        name
        expr
        
        % data
        data
        dataIdx
        obs = 0
        dt
        dd
        ds
        idd
        ids
        
        % computed
        time
        init
        prev
        curr
        val
        
        % meta
        unitType
        unit
        label
    end
    methods
        function this = ModelComponent(index, name, metaData)
            this.index = index;
            this.name = name;
            
%             this.data.field = [];
%             this.data.val = [];
%             this.data.std = [];
            
            if ~isempty(metaData)
                this.unitType = metaData{1};
                this.unit = metaData{2};
                this.label = metaData{3};
            end
        end
    end
end