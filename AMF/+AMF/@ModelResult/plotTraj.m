function plotTraj(this, comp, colorMap)

import AMF.utils.defineCustomColormap

[sseSorted, sseIdx] = sort(sum(this.sse), 'descend');

numIter = this.options.numIter;

for it = 1:numIter
    itIdx = sseIdx(it);
    plot(comp.time, comp.val(:,itIdx), 'Color', colorMap(it,:));
end

if ~isempty(comp.data)
    data.time = comp.data.source.time;
    data.val = comp.data.source.val;
    data.std = comp.data.source.std;

    errorbar(data.time, data.val, data.std, 'k--', 'LineWidth', 2);
end