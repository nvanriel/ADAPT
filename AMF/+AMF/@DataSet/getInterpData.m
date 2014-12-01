function [dd, ds] = getInterpData(this, t, method)

if nargin < 3
    method = 'spline';
end

[dd, ds] = interp(this.fields, t, method);

if ~isempty(this.functions)
    [dd, ds] = this.funcs.func(dd, ds, getDataStruct(this));
end