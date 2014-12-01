function this = setFitParameters(this, t, p, ts)

if nargin < 4, ts = 0; end

for i = 1:length(this.fitParameters)
    this.fitParameters(i).curr = p(:,i);
end
parseInputs(this);

if ts > 0
    this.result.p(ts,:) = p;
else
    this.result.p = p;
end