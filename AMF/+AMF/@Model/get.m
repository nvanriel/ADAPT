function comps = get(this, varargin)

for i = 1:length(varargin)
    compName = varargin{i};
    
    comps(i) = this.ref.(compName);
end