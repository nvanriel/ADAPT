function this = parseFunctions(this)

dataStruct = this.data.(this.activeGroup);

for field = this.functions
    if ~isempty(field.timeField)
        field.src.time = dataStruct.(field.timeField);
    end

end