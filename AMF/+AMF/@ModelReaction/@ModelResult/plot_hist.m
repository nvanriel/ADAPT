function this = plot_hist(this, t, r, xlab, ylab, colors)
if strcmp(colors, 'blue')
    cs = {[1 1 1] [0 0 0.8] [0 0 0.2]};
elseif strcmp(colors, 'red')
    cs = {[1 1 1] [0.8 0 0] [0.2 0 0]};
end
cm = AMF.utils.define_custom_colormap(cs, 100);

ny = 100;
[N,C] = AMF.utils.getHist(t,r',[],ny);
pcolor(C{1},C{2},N');
shading flat;

xlabel(xlab)
ylabel(ylab)
colormap(cm)
axis([min(C{1})-1 max(C{1})+1 min(C{2}) max(C{2})])
end
