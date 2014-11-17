function this = randomizeData(this)

t = getTime(this);
comps = filter(this, @isObservable);

for i = 1:length(comps)
    comp = comps{i};
    genRandSpline(comp.data);
    interp(comp.data, t, 'RAND_SPLINE');
end