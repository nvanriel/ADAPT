function this = initiateExperiment(this, dataset)

this.dataset = dataset;
interp(this.dataset, 0, 'spline');

observables = filter(this.dataset, @isObservable);

this.fitTime = [];

for i = 1:length(observables)
    dataField = observables{i};
    this.fitTime = [this.fitTime, dataField.src.time];
end

this.fitTime = sort(unique(this.fitTime));

for i = 1:length(observables)
    dataField = observables{i};
    fieldName = dataField.name;
    
    comp = this.ref.(fieldName);
    comp.data = dataField;
    
    dataField.fitIdx = arrayfun(@(t) find(this.fitTime == t), dataField.src.time);
end