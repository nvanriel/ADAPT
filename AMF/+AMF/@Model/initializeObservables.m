function this = initializeObservables(this)

observables = filter(this, @isObservable);

for i = 1:length(observables)
    comp = observables{i};
    comp.init = comp.data.val(1);
end