function this = computeAll(this, t, x0, p, ts)

if nargin < 5, ts = 0; end

% compute
x = computeStates(this, t, x0, p);

if ts > 0
    t = t(end);
    x = x(end,:);
end

u = this.computeInputs(t);
v = this.computeReactions(t, x, p);

% update the component current values
for i = 1:length(this.states)
    this.states(i).curr = x(:,i);
end
for i = 1:length(this.reactions)
    this.reactions(i).curr = v(:,i);
end
for i = 1:length(this.inputs)
    this.inputs(i).curr = u(:,i);
end

% store the values in the trajectories
if ts > 0
    this.result.x(ts,:) = x;
    this.result.v(ts,:) = v;
    if ~isempty(this.inputs)
        this.result.u(ts,:) = u;
    end
else
    this.result.x = x;
    this.result.v = v;
    this.result.u = u;
end