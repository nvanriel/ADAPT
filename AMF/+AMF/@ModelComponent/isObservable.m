function filter = isObservable(compArray)

n = length(compArray);
filter = zeros(1, n);
for i = 1:n
    filter(i) = isa(compArray(i).data, 'AMF.DataField');
end

filter = logical(filter);