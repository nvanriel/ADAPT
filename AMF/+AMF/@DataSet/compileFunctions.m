function this = compileFunctions(this)

if isempty(this.functions)
    return
end

import AMF.utils.writeFile

%
% Data functions
%

fn = char(this.funcs.func);

header = ['function [dd, ds] = ', fn, '(dd,ds,d)\n\n'];

DD = {};
DS = {};
n = length(this.fields);
for i = 1:length(this.fields)
    comp = this.fields(i);
    DD{i} = [comp.name, ' = dd(:, d.d.', comp.name, ');\n'];
    DS{i} = [comp.name, ' = ds(:, d.d.', comp.name, ');\n'];
end

DFD = {}; EDFD = {};
DFS = {}; EDFS = {};
for i = 1:length(this.functions)
    comp = this.functions(i);
    DFD{i} = [comp.name, ' = ', comp.valExpr, ';\n'];
    DFS{i} = [comp.name, ' = ', comp.stdExpr, ';\n'];
    EDFD{i} = ['dd(:, ', num2str(comp.index), ') = ', comp.name, ';\n'];
    EDFS{i} = ['ds(:, ', num2str(comp.index), ') = ', comp.name, ';\n'];
end

content = [DD{:}, '\n', DFD{:}, '\n', EDFD{:}, '\n', DS{:}, '\n', DFS{:}, '\n', EDFS{:}];

writeFile([this.compileDir, fn, '.m'], [header, content]);