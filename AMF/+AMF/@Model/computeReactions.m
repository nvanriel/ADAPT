function v = computeReactions(this, t, x, p, uvec)

n = length(t);
v = zeros(n, length(this.reactions));

m = this.mStruct;
for i = 1:n
    v(i,:) = this.functions.reactions(t(i), x(i,:), p, uvec, m);
end