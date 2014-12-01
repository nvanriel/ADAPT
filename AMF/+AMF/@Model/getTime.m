function t = getTime(this, ts)

if nargin < 2, ts = 0; end

t = this.predictor.val(1):this.predictor.val(end)/this.options.numTimeSteps:this.predictor.val(end);

if ts > 0
    SSTime = this.options.SSTime;
    
    if ts > 1
        t = [t(ts-1); (t(ts-1)+t(ts))/2; t(ts)];
    else
        t0 = t(ts)-SSTime;
        t = [t0; (t0+t(ts))/2; t(ts)];
    end
end

t = t(:);