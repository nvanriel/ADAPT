function [comps, n] = getAll(this, type)

compClass = this.template.(upper(type));

idx = cellfun(@(comp) isa(comp, compClass), this.list);

comps = this.list(idx);
comps = [comps{:}];

n = length(comps);