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
        
        src
        curr
        
        time
        val
        std

        ppform
        options
        
        fitIdx
    end
    methods
        function this = DataComponent(varargin)
        end
    end
end