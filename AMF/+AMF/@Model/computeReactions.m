function v = computeReactions(this, time, x, p)

m = getInputStruct(this);
for i = 1:length(time)
    t = time(i);
    v(i,:) = this.functions.reactions(t, x(i,:), p, m);
end