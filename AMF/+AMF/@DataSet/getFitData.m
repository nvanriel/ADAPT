function [dd, ds] = getFitData(this)

ft = getFitTime(this);
tt = nan(size(ft));

for i = 1:length(this.fields)
    df = this.fields(i);
    t = df.src.time;
    idx = ismember(ft, t);
    
    if isempty(t)
        d = ones(size(ft)) * df.curr.val(1);
        s = ones(size(ft)) * df.curr.std(1);
    else
        d = tt; d(idx) = df.curr.val;
        s = tt; s(idx) = df.curr.std;
    end

    dd(:,i) = d;
    ds(:,i) = s;
end

if ~isempty(this.functions)
    [dd, ds] = this.funcs.func(dd, ds, getDataStruct(this));
end