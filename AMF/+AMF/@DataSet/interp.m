function this = interp(this, t, method)

if nargin < 3, method = 'LINEAR'; end

interp(this.fields, t, method);

parseFunctions(this);