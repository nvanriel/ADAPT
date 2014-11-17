function this = setFitParameters(this, t, p, ts)

if nargin < 4, ts = 0; end

save(this.fitParameters, t, p, ts);
parseInputs(this);