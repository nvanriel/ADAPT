function s = getStruct(compArr)

for i = 1:length(compArr)
    comp = compArr(i);
    
    props = properties(comp);
    for j = 1:length(props)
        propName = props{j};
        s(i).(propName) = comp.(propName);
    end
end