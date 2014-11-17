function compArray = save(compArray, t, val, ts)

if nargin < 4, ts = 0; end

for i = 1:length(compArray)
    comp = compArray(i);

    comp.curr = val(:,i);
    
    if ts
        comp.val(ts) = val(i);
        comp.time(ts) = t(end);
    else
        comp.val = val(:,i) .* ones(size(t(:)));
        comp.time = t(:);
    end
end