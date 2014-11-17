function fields = get(this, varargin)

for i = 1:length(varargin)
    fieldName = varargin{i};
    
    fields(i) = this.ref.(fieldName);
end