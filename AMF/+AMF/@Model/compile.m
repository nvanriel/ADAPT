function this = compile(this)

prefix = 'C';

%
% ODE
%

fn = [prefix, '_', this.name, '_ODE'];
fid = fopen([fn, '.m'], 'w');

fprintf(fid, ['function dxdt = ', fn, '(t,x,p,m)\n']);

[states, n] = filterByType(this, 'State');
for i = 1:n
    comp = states(i);
    fprintf(fid, ['dxdt(', num2str(states(i).index) ,')', ' = ' ,comp.compiledExpr, ';\n']);
end

fprintf(fid, '\ndxdt = dxdt(:);');
fclose(fid);

% %
% % Inputs
% %
% 
% fn = [prefix, '_', this.name, '_Inputs'];
% fid = fopen([fn, '.m'], 'w');
% 
% fprintf(fid, ['function u = ', fn, '(t,m)\n']);
% 
% [inputs, n] = filterByType(this, 'Input');
% for i = 1:n
%     comp = inputs(i);
%     fprintf(fid, [comp.compiledVar, ' = ' ,comp.compiledExpr, ';\n']);
% end
% 
% fclose(fid);
% 
% %
% % Reactions
% %
% 
% fn = [prefix, '_', this.name, '_Reactions'];
% fid = fopen([fn, '.m'], 'w');
% 
% fprintf(fid, ['function v = ', fn, '(t,x,p,m)\n']);
% 
% [reactions, n] = filterByType(this, 'Reaction');
% for i = 1:n
%     comp = reactions(i);
%     fprintf(fid, [comp.compiledVar, ' = ' ,comp.compiledExpr, ';\n']);
% end
% 
% fclose(fid);
% 
% % EXPERIMENTAL
% 
% %
% % Constraints
% %
% 
% fn = [prefix, '_', this.name, '_Constraints'];
% fid = fopen([fn, '.m'], 'w');
% 
% fprintf(fid, ['function E = ', fn, '(model)\n']);
% 
% n = size(this.spec.CONSTRAINTS, 1);
% for i = 1:n
%     expr = this.spec.CONSTRAINTS{i,1};
%     weight = this.spec.CONSTRAINTS{i,2};
%     
%     vars = symvar(expr);
%     for j = 1:length(vars)
%         var = char(vars(j));
%         expr = regexprep(expr, var, ['model.comps.', var]);
%     end
%     
%     fprintf(fid, ['E(', num2str(i) ,') = ' ,expr, '* ', num2str(weight),';\n']);
% end
% 
% fprintf(fid, 'E = E(:);\n');
% fclose(fid);