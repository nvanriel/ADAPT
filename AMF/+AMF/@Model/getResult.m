function result = getResult(this)

result.predictor = getStruct(this.predictor);
result.parameters = getStruct(this.parameters);
result.states = getStruct(this.states);
result.reactions = getStruct(this.reactions);

result.options = this.options;

if ~isempty(this.constants)
    result.constants = getStruct(this.constants);
else
    result.constants = [];
end

if ~isempty(this.inputs)
    result.inputs = getStruct(this.inputs);
else
    result.inputs = [];
end

result.time = getTime(this);