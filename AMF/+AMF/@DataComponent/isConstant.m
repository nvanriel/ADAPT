function filter = isConstant(fieldArr)

filter = zeros(1, length(fieldArr));
for i = 1:length(fieldArr)
    field = fieldArr(i);
    filter(i) = length(field.src.time);
end
filter = filter < 2;