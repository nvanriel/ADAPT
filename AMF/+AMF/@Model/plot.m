function this = plot(this, name)

comp = this.ref.(name);

plot(this.time, comp.val, 'r');

if ~isempty(comp.data)
    data.time = comp.data.src.time;
    data.val = comp.data.src.val;
    data.std = comp.data.src.std;

    hold on
    if any(data.std)
        errorbar(data.time, data.val, data.std, 'kx', 'LineWidth', 2);
    else
        plot(data.time, data.val, 'kx', 'LineWidth', 2);
    end
    hold off
end

xlabel([this.predictor.unitType, ' [', this.predictor.unit, ']']);
xlim([comp.time(1) comp.time(end)]);

if comp.label
    title(comp.label);
else
    title(comp.name);
end

if comp.unit
    ylabel(sprintf('%s [%s]', comp.unitType, comp.unit));
else
    ylabel(comp.unitType);
end

% function this = plot(this, compName)
% 
% comp = this.ref.(compName);
% 
% plot(this.getTime(), comp.val);
% 
% title(comp.label);
% xlabel([this.predictor.unitType, '[', this.predictor.unit, ']']);
% ylabel([comp.unitType, '[', comp.unit, ']']);
% 
% if isObservable(comp);
%     hold on;
%     plot(comp.data);
%     hold off;
% end
% 
% xlim([this.predictor.val(1) this.predictor.val(end)]);