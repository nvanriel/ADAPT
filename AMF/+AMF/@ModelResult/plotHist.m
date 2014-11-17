function this = plotHist(this, comp, colorMap)

ny = length(comp.time);
[N,C] = AMF.utils.getHist(comp.time,comp.val',[],ny);
pcolor(C{1},C{2},N');
shading flat;

colormap(colorMap);
axis([min(C{1})-1 max(C{1})+1 min(C{2}) max(C{2})])