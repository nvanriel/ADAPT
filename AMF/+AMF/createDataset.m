function dataset = createDataset(dataFile)

import AMF.*

specification = feval(dataFile);

if isfield(specification, 'DESCRIPTION')
    description = specification.DESCRIPTION;
else
    description = [];
end

if isfield(specification, 'TYPE')
    type = specification.TYPE;
else
    type = [];
end

if ~isfield(specification, 'GROUPS')
    error('A dataset requires at least one group.');
end

groups = specification.GROUPS;

if ~isfield(specification, 'FILE')
    error('A dataset requires a MAT file containing the experimental data values.');
end

data = load([specification.FILE, '.mat']);

if isfield(specification, 'FIELDS')
    spec = specification.FIELDS;

    fields = AMF.DataField.empty;
    for i = 1:size(spec, 1)
        args = spec(i, :);
        fields(i) = AMF.DataField(i, args{:});
    end
else
    error('A dataset requires at least one defined data field.');
end

if isfield(specification, 'FUNCTIONS')
    spec = specification.FUNCTIONS;
    
    functions = AMF.DataFunction.empty;
    for i = 1:size(spec, 1)
        args = spec(i,:);
        functions(i) = AMF.DataFunction(i, args{:});
    end
end

dataset.a = fields;
dataset.f = functions;