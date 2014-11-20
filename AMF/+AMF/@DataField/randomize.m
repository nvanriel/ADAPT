function fieldArr = randomize(fieldArr)

for field = fieldArr
    if ~isempty(field.src.std)
        field.curr.val = field.src.val + randn(size(field.src.val)) .* field.src.std;

        genSpline(field);
    end
end