% AUC.m
% Approximates the area under curve (AUC)
% using cumultative trapezoidal numerical
% integration.
function val = AUC(comp)

tmp = cumtrapz(comp.time, comp.curr);
val = tmp(end);