function [var_name,short_name,full_name,unit,index] = get_info_mc(modeltype,input,m)

% -- type of model component
switch modeltype
    case 'state'
        type = 'x';
    case 'flux'
        type = 'j';    
    case 'parameter'
        type = 'p';
    case 'observable';
        type = 'y';
    case 'input';
        type = 'u';
end



if ischar(input) %string
    var_name = input;
    N = length(m.info.(type));

    for i = 1:N
        item = m.info.(type)(i);
        item = item{1};
        if strcmp(item{1},var_name)
            full_name = item{2};
            unit = item{3};
            index = i;
            if length(item)==4
                short_name = item{4};
            else
                short_name = define_short_name(var_name);
            end
        end
    end
       

else %number
    index = input;
    
    item = m.info.(type)(index);
    item = item{1};
    
    var_name = item{1};
    full_name = item{2};
    unit = item{3};
    
    if length(item)==4
        short_name = char(item(4));
    else
        short_name = define_short_name(var_name);
    end
end


% =========================================================================
function short_name = define_short_name(var_name)
ind = strfind(var_name,'_');
if ~isempty(ind)   
    short_name = var_name(1:ind(1)-1);
    for i = 1:length(ind)
        if i < length(ind)
            add = [var_name(ind(i)) '{' var_name(ind(i)+1:ind(i+1)-1) '}'];
        else
            add = [var_name(ind(i)) '{' var_name(ind(i)+1:end) '}'];
        end
        short_name = [short_name add];
    end
else
    short_name = var_name;
end