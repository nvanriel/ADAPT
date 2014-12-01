function d = getDataStruct(this)

nf = length(this.fields);
for i = 1:nf
    d.d.(this.fields(i).name) = this.fields(i).index;
end
for i = 1:length(this.functions)
    d.d.(this.functions(i).name) = this.functions(i).index;
end