function this = compileReactions(this)

import AMF.utils.writeFile

%
% ODE
%

fn = char(this.functions.reactions);

header = ['function v = ', fn, '(t,x,p,u,m)\n\n'];

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
    RC{i} = [comp.name, ' = ', AMF.utils.mexify2(comp.expr, comp.name), ';\n'];
end

RRC = {};
for i = 1:length(this.reactions);
    comp = this.reactions(i);
    RRC{i} = ['v(', num2str(comp.index), ') = ', comp.name, ';\n'];
end

content = [IC{:}, '\n', CC{:}, '\n', SC{:}, '\n', PC{:}, '\n', RC{:}, '\n', RRC{:}];

writeFile([this.compileDir, fn, '.m'], [header, content]);