function result = computeAll(this, t, x0, p, ts)

if nargin < 5, ts = 0; end

u = this.computeInputs(t);

if ~isempty(this.inputs)
    save(this.inputs, t, u, ts);
end

x = computeStates(this, t, x0, p);
v = this.computeReactions(t, x, p);

if ts > 0
    x = x(end,:);
    v = v(end,:);
    if ~isempty(u)
        u = u(end,:);
    end
end

save(this.states, t, x, ts);
save(this.reactions, t, v, ts);

result.t = t;
result.x = x;
result.v = v;
result.u = u;
result.p = p;