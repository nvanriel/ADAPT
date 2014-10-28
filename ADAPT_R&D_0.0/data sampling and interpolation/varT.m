function y = varT(x)

nx = numel(x);
meanx2 = sum(x.^2) / nx;
mean2x = (sum(x) / nx)^2;

y = (meanx2 - mean2x) * (nx/(nx-1));