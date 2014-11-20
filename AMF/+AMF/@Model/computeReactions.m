function v = computeReactions(this, time, x, p)

m = this.mStruct;
for i = 1:length(time)
    t = time(i);
    v(i,:) = this.functions.reactions(t, x(i,:), p, getInputsMex(this), m);
end