function var_ind = scrt(Tx, var_ind)
%allows scrolling through table columns by calling it repeatedly
var_name = Tx.Properties.VariableNames(var_ind);
sorted = sortrows(Tx(:,var_name), var_name{1}, 'descend')
var_ind = var_ind+1;

end

