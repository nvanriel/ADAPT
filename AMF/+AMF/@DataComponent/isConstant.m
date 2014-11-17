function filter = isConstant(fieldArr)

filter = zeros(1, length(fieldArr));
for i = 1:length(fieldArr)
    field = fieldArr(i);
    filter(i) = length(field.source.val);
end
filter = filter == 1;