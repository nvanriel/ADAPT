function this = compileInputs(this)

if isempty(this.inputs)
    return
end

import AMF.utils.writeFile

%
% ODE
%

fn = char(this.functions.inputs);

header = ['function u = ', fn, '(t,uv,m)\n\n'];

for i = 1:length(this.inputs)
    comp = this.inputs(i);
    IC{i} = ['u(', num2str(comp.index), ') = interp1(uv(m.u.', comp.name, '_t), ', 'uv(m.u.', comp.name, '), t, ''', comp.method, ''', ''extrap'');\n'];
end

content = [IC{:}];

writeFile([this.compileDir, fn, '.m'], [header, content]);