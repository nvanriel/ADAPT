function [val, std] = interpLinear(field, t)

val = interp1(field.src.time, field.curr.val, t, 'linaer', 'extrap');
    
if any(field.curr.std)
    std = sqrt(interp1(field.src.time, field.curr.std .^ 2, t, 'linear', 'extrap'))';
else
    std = [];
end