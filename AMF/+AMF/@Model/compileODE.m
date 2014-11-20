function this = compileODE(this)

import AMF.utils.writeFile

%
% ODE
%

fn = char(this.functions.ODE);

header = ['function dxdt = ', fn, '(t,x,p,u,m)\n\n'];

CC = {};
for i = 1:length(this.constants)
    comp = this.constants(i);
    CC{i} = [comp.name, ' = m.c.', comp.name, ';\n'];
end

IC = {};
for i = 1:length(this.inputs)
    comp = this.inputs(i);
    IC{i} = [comp.name, ' = interp1(u(m.u.', comp.name, '_t), ', 'u(m.u.', comp.name, '), t, ''', comp.method, ''', ''extrap'');\n'];
end

SC = {};
for i = 1:length(this.states)
    comp = this.states(i);
    SC{i} = [comp.name, ' = x(m.s.', comp.name, ');\n'];
end

PC = {};
for i = 1:length(this.parameters)
    comp = this.parameters(i);
    PC{i} = [comp.name, ' = p(m.p.', comp.name, ');\n'];
end

RC = {};
for i = 1:length(this.reactions)
    comp = this.reactions(i);
    RC{i} = [comp.name, ' = ', comp.expr, ';\n'];
end

OC = {};
for i = 1:length(this.states)
    comp = this.states(i);
    OC{i} = ['dxdt(', num2str(comp.index), ') = ', comp.expr, ';\n'];
end

footer = '\ndxdt = dxdt(:);';

content = [IC{:}, '\n', CC{:}, '\n', SC{:}, '\n', PC{:}, '\n', RC{:}, '\n', OC{:}];

writeFile([this.compileDir, fn, '.m'], [header, content, footer]);