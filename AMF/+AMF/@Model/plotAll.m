function this = plotAll(this, type)

comps = this.(type);
n = length(comps);
ns = sqrt(n);

for i = 1:n
    subplot(ceil(ns),ceil(ns),i); hold on;
    plot(this, comps(i).name);
end