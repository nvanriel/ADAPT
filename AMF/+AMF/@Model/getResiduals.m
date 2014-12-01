function resid = getResiduals(this, ts)

import AMF.regFun

if nargin < 2, ts = 0; end

% observables = filter(this, @isObservable);
observables = this.observables;

% compute error from observables
resid = 0;
for i = 1:length(observables)
    comp = observables{i};
    
    if ts > 0
        err = comp.data.val(ts)-comp.curr(:);
        
        if any(comp.data.std)
            err = err ./ comp.data.std(ts);
        else
            err = err ./ comp.data.val(ts);
        end
    else
        idx = comp.data.fitIdx;
        err = comp.data.src.val(:)-comp.curr(idx);
        
        if any(comp.data.std)
            err = err ./ comp.data.src.std(:);
        else
            err = err ./ comp.data.src.val(:);
        end
    end
    
    resid = [resid; err];
end

% pad error to prevent lsqnonlin warnings
resid = [resid; zeros(length(this.fitParameters), 1)];

% standard ADAPT regularization
regADAPT = regFun(this);
resid = [resid; regADAPT(:)];

% additional regularization
if ~isempty(this.functions.reg)
    reg = this.functions.reg(this);
    resid = [resid; reg(:)];
end

% remove NaNs (caused by single time point data or zero divisions in model reactions or state derivatives)
resid(isnan(resid)) = 0;
resid(isinf(resid)) = 0;