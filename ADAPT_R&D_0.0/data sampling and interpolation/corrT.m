function c = corrT(x,y)

nx = numel(x);
mx = sum(x)/nx;
my = sum(y)/nx;
sx = sqrt(varT(x));
sy = sqrt(varT(y));
c = sum((x-mx).*(y-my)) / ((nx-1)*sx*sy);
if isinf(c), c = 0; end;
if isnan(c), c = 0; end;
c = min([c,1]);
c = max([c,-1]);