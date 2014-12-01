function pcurr = randomizeParameters(this)

np = length(this.fitParameters);

smax = this.options.parScale(1);
smin = this.options.parScale(2);
pcurr = 10.^((smax-smin)*rand(np,1)+smin);

for i = 1:np
    this.fitParameters(i).init = pcurr(i);
    this.fitParameters(i).curr = pcurr(i);
end

this.result.pcurr = [this.parameters.init];
this.result.pinit = [this.parameters.init];