function fieldArr = genRandSpline(fieldArr)

for i = 1:length(fieldArr)
    field = fieldArr(i);
    
    if isConstant(field)
        continue
    end

    t   = field.source.time;
    dm  = field.source.val;
    ds  = field.source.std;
    smooth = field.smooth;

    dd  = dm + randn(size(ds)).*ds; % <---------------------
    w   = (1 ./ ds ).^2;

    if (sum(isinf(w))==0)
        field.source.ppform = csaps(t,dd,smooth,[],w);
    else
        field.source.ppform = csaps(t,dd,smooth,[]);
    end
end