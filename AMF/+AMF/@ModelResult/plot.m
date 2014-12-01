function this = plot(this, names, mode)

if nargin < 3, mode = 'TRAJ'; end

import AMF.utils.defineCustomColormap

if isa(names, 'char')
    names = {names};
end

n = length(names);
ns = sqrt(n);

numIter = this.options.numIter;

for i = 1:length(names)
    subplot(ceil(ns),ceil(ns),i); hold on;
    name = names{i};

    comp = this.ref.(name);

    switch upper(mode)
        case 'TRAJ'
            colorMap = defineCustomColormap({[0.8 0.6 0.6] [0.8 0 0] [0.2 0 0]}, numIter);
            plotTraj(this, comp, colorMap);

        case 'HIST'
            colorMap = defineCustomColormap({[1 1 1] [0.8 0 0] [0.2 0 0]}, numIter);
            plotHist(this, comp, colorMap);

        case 'HIST_LOG'

            % TODO: plot logarithmic histograms

        otherwise
            error('Unknown plot mode %s', mode);
    end

    xlabel([this.predictor.unitType, ' [', this.predictor.unit, ']']);
    xlim([this.time(1) this.time(end)]);

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
end