function [val, std] = interpLinear(field, t)

val = interp1(field.source.time, field.source.val, t, 'linaer', 'extrap');
std = sqrt(interp1(field.source.time, field.source.std .^ 2, t, 'linear', 'extrap'))';