function fieldArr = restore(fieldArr)

for field = fieldArr
    field.curr.val = field.src.val;
    field.curr.std = field.src.std;

    genSpline(field);
end