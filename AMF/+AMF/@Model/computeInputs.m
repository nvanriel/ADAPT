function u = computeInputs(this, time)

if isempty(this.inputs)
    u = [];
    return
end

m = getInputStruct(this);
for i = 1:length(time)
    t = time(i);
    u(i,:) = this.functions.inputs(t, m);
end