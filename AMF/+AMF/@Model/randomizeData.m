function this = randomizeData(this)

randomize(this.dataset);

t = getTime(this);

[idd, ids] = getInterpData(this.dataset, t, 'spline');

this.result.idd = idd;
this.result.ids = ids;