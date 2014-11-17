function error = minCPepReg(model)

h = get(model, 'h');
Gb = get(model, 'Gb');

if h.val < Gb.val
    error = Gb.val - h.val;
else
    error = 0;
end