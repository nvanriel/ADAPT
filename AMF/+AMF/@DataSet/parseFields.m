function this = parseFields(this)

dataStruct = this.data.(this.activeGroup);

for field = this.fields
    if ~isempty(field.timeField)
        field.src.time = dataStruct.(field.timeField);
    end

    field.src.val = dataStruct.(field.valField) * field.unitConv;
    
    if ~isempty(field.stdField)
        field.src.std = dataStruct.(field.stdField) * field.unitConv;
    end
    
    restore(field);
end