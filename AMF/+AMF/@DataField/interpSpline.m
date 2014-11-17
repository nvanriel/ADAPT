function [val, std] = interpSpline(field)

val = interp1(field.source.time, field.source.val, t, 'spline', 'extrap');
std = sqrt(interp1(field.source.time, field.source.std .^ 2, t, 'spline', 'extrap'))';