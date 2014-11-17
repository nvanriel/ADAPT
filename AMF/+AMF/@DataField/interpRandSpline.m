function [val, std] = interpRandSpline(field, t)

if isempty(field.source.ppform)
    genRandSpline(field);
end

val = ppval(field.source.ppform, t)';
std = sqrt(interp1(field.source.time, field.source.std .^ 2, t, 'linear','extrap'))';