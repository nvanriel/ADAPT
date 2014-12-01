function plotTraj(this, comp, colorMap)

import AMF.utils.defineCustomColormap

[~, sseIdx] = sort(sum(this.sse), 'descend');

numIter = length(this.result);

for it = 1:numIter
    itIdx = sseIdx(it);
    if numIter == 1
        plotColor = [1 0 0];
    else
        plotColor = colorMap(it,:);
    end
    
    plot(this.time, comp.val(:,itIdx), 'Color', plotColor);
end

if comp.obs
    errorbar(comp.dt, comp.dd, comp.ds, 'k--', 'LineWidth', 2);
end