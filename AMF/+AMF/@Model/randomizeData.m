function this = randomizeData(this)

t = getTime(this);
comps = filter(this, @isObservable);

for i = 1:length(comps)
    comp = comps{i};
    randomize(comp.data);
%     interp(comp.data, t, 'SPLINE');
end

interp(this.dataset, t, 'SPLINE');