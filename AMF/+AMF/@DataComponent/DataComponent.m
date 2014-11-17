classdef DataComponent < handle
    properties
        name
        obs
        index
        
        timeField
        valField
        stdField
        
        unitConv
        smooth
        
        source
        time
        val
        std

        options
        
        fitIdx
    end
    methods
        function this = DataComponent(varargin)
        end
    end
end