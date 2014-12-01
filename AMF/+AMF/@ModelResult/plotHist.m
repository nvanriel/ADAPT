function this = plotHist(this, comp, colorMap)

ny = round(length(this.time) / 2); % proper bin count ??

[N,C] = AMF.utils.getHist(this.time,comp.val',[],ny);
pcolor(C{1},C{2},N');
shading flat;

colormap(colorMap);
axis([min(C{1})-1 max(C{1})+1 min(C{2}) max(C{2})])

if comp.obs
    errorbar(comp.dt, comp.dd, comp.ds, 'k--', 'LineWidth', 2);
end