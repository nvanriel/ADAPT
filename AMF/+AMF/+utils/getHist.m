function [N,C] = getHist(t,v,r,ny)

a = repmat(t,size(v,1),1);
b = reshape(v.',numel(v),1);

if numel(r) > 0
    [N, C] = hist3([a,b],{t,[r(1) : (r(2)-r(1))/(ny-1) : r(2)]});
else
    [N, C] = hist3([a,b],[numel(t) ny]);
end
N = log10(N);
N = N./max(max(N));

N(N==-inf) = 0;