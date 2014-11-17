function resid = getResiduals(this, ts)

if nargin < 2, ts = 0; end

observables = filter(this, @isObservable);

% compute error from observables
resid = 0;
for i = 1:length(observables)
    comp = observables{i};
    
    if ts > 0
        resid = [resid; this.functions.errStep(comp, ts)];
    else
        resid = [resid; this.functions.err(comp)];
    end
end

% pad error to prevent lsqnonlin warnings
resid = [resid; zeros(length(this.fitParameters), 1)];

% compute regularization error
if ~isempty(this.functions.reg)
    reg = this.functions.reg(this);
    resid = [resid; reg(:)];
end