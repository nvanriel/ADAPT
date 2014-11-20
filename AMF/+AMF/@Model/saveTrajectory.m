function this = saveTrajectory(this)

x = this.result.x;
v = this.result.v;
u = this.result.u;
p = this.result.p;

for i = 1:length(this.states)
    this.states(i).val = x(:,i);
end
for i = 1:length(this.reactions)
    this.reactions(i).val = v(:,i);
end
for i = 1:length(this.inputs)
    this.inputs(i).val = u(:,i);
end
for i = 1:length(this.fitParameters)
    this.fitParameters(i).val = p(:,i);
end