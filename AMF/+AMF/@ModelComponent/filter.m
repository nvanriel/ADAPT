function comps = filter(compArray, func)

idx = logical(func(compArray));
comps = compArray(idx);