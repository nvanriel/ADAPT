function fieldArr = genSpline(fieldArr)

for i = 1:length(fieldArr)
    field = fieldArr(i);

    if isConstant(field)
        continue
    end

    t   = field.src.time;
    dd  = field.curr.val;
    ds  = field.curr.std;
    smooth = field.smooth;

    w   = (1 ./ ds ).^2;

    if (sum(isinf(w))==0)
        field.ppform = csaps(t,dd,smooth,[],w);
    else
        field.ppform = csaps(t,dd,smooth,[]);
    end
end