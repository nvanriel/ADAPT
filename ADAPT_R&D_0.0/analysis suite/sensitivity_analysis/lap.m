function TTx = lap(Tx, par)
% have a look at sensitivity coefficients for specific parameter by
% transposing table and sorting values
varnames = Tx.Properties.VariableNames;
aTx = table2array(Tx(par,:));
taTx = aTx';
TTx = array2table(taTx, 'RowNames', varnames, 'VariableNames', {par});
TTx = sortrows(TTx, par, 'descend');
end

