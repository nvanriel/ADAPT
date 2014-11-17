function this = plot_traj(this, t, r, vals, xlab, ylab, colors)

t = this.time;
r = 

if strcmp(colors, 'blue')
    cs = {[0.6 0.6 0.8] [0 0 0.8] [0 0 0.2]};
elseif strcmp(colors, 'red')
    cs = {[0.8 0.6 0.6] [0.8 0 0] [0.2 0 0]};
end
length_colormap = 101;
cm = AMF.utils.define_custom_colormap(cs, length_colormap);


for it=1:size(r,2)
    plot(t, r(:,it), 'Color', cm(1+100-(round(vals(it)*100)),:));
    hold on
end
xlabel(xlab)
ylabel(ylab)
end