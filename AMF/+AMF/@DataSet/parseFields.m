function this = parseFields(this)

dataStruct = this.data.(this.activeGroup);

for field = this.fields
    if field.timeField
        field.source.time = dataStruct.(field.timeField);
    end

    field.source.val = dataStruct.(field.valField) * field.unitConv;
    field.source.std = dataStruct.(field.stdField) * field.unitConv;
end