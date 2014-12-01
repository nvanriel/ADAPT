function u = computeInputs(this, time, uvec)

if isempty(this.inputs)
    u = [];
    return
end

m = this.mStruct;
for i = 1:length(time)
    t = time(i);
    u(i,:) = this.functions.inputs(t, uvec, m);
end