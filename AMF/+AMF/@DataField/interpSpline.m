function [val, std] = interpSpline(field, t)

if isempty(field.ppform)
    genSpline(field);
end

val = ppval(field.ppform, t)';

if any(field.curr.std)
    std = sqrt(interp1(field.src.time, field.curr.std .^ 2, t, 'linear','extrap'))';
else
    std = [];
end