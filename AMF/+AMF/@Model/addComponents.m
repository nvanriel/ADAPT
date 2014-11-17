function this = addComponents(this, groupName, spec, compType)

this.template.(groupName) = func2str(compType);

if ~isfield(spec, groupName)
    return
end

compSpec = spec.(groupName);
for i = 1:size(compSpec, 1)
    name = compSpec{i, 1};
    this.ref.(name) = compType(i, compSpec{i, :});
end