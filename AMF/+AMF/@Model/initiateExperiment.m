function this = initiateExperiment(this, dataset)

this.dataset = dataset;

observables = filter(this.dataset, @isObservable);

for i = 1:length(observables)
    df = observables{i};
    name = df.name;
    
    this.ref.(name).obs = 1;
    this.ref.(name).dataIdx = df.index;
end

% save observable indices (states, reactions corresponding data)
this.result.oxi = logical([this.states.obs]);
this.result.ofi = logical([this.reactions.obs]);
this.result.oxdi = [this.states.dataIdx];
this.result.ofdi = [this.reactions.dataIdx];

%
dt = getFitTime(this.dataset);
[dd, ds] = getFitData(this.dataset);

this.result.dt = dt(:);
this.result.dd = dd;
this.result.ds = ds;

this.dStruct = getDataStruct(this.dataset);