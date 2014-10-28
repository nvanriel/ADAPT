function filename = generate_model_files(m,type)

    filename = [type '_' m.modelname];
    switch type
        case 'MEX' % MEX description: automatically compile MEX file from ODE file
            ODE_file = [func2str(m.info.odefile) '.m'];
            
            if ~exist([pwd '\model\' filename '.mexw64'],'file')
                convertToC(m,ODE_file);
                compileC(filename)

                movefile([pwd '\' filename '.mexw64'],[pwd '\model\' filename '.mexw64'])
                filename = str2func([type '_' m.modelname]);

                disp([char(10) ' *** compiling successful; MEX file generated'])
            else
                filename = str2func(filename);
            end
            
        otherwise  % automatically write m files
            if 1%~exist([pwd '\model\' filename],'file')
                disp([' *** compiling ' type ' file'])
                
                % -- construct file components
                header  = get_header(m,type);
                body    = get_body(m,type);
                footer  = get_footer(type);
                content = [header body{:} footer];

                % -- write content to m-file
                m_file = fopen([pwd '\model\' filename '.m'],'w');
                fprintf(m_file,content);
                fclose(m_file);
            end
            filename = str2func([type '_' m.modelname]);
    end
end

% =========================================================================
function header = get_header(m,type)
    switch type
        case 'flux'
            output_var = 'j';
            input_var = 't,x,p,u,m';
        case 'ODE'
            output_var = 'dxdt';
            input_var = 't,x,p,u,m';
        case 'observables'
            output_var = 'y';
            input_var = 't,x,j,p,u,m';
        case 'costfunc'
            output_var = 'error';
            input_var = 'p,p_prev,p0,u,x0,tspan,data,gene_data,R,m';
    end
    
    header = sprintf('function %s = %s_%s(%s)\n',output_var,type,m.modelname,input_var);
end

% =========================================================================
function body = get_body(m,type)
    switch type
        case 'costfunc'
            body{1} = '\n\n%% -- compute model simulation\n';
            body{end+1} = sprintf('[t,x_sim,j_sim,y_sim] = simulate_model(tspan,x0,p,p0,u,m);\n\n\n');
            
            try fields = fieldnames(m.par_ass_genes);
                body{end+1} = sprintf('\tp_diff = ( (p-p_prev) ./ p0) / (t(end)-t(1));\n');
                body{end+1} = sprintf('\tp_diff = p_diff(1:length(p));\n\n');
                body{end+1} = sprintf('\tmindiff = 1e-6;\n\n');
                body{end+1} = sprintf('\tpdreg = [\n');
                for i = 1:length(fields)
                    associated_genes = m.par_ass_genes.(fields{i});
                    for j = 1:length(associated_genes)
                        body{end+1} = sprintf('\t\t\tsqrt(1/%d) * p_diff(%d) ./ (max([gene_data.%s.diff, mindiff]))\n', length(associated_genes), m.p.(fields{i}), m.info.genes{associated_genes(j)});
                    end
                end
                body{end+1} = sprintf('\t\t\tp_diff([');
                body{end+1} = sprintf('%d ', m.not_associated);
                body{end+1} = sprintf('])];\n');
%                 body{end+1} = sprintf('\t\t\t];\n\n');
                body{end+1} = sprintf('\tR.p = [R.p,p];\n');
                body{end+1} = sprintf('\tcr = [\n');
                for i = 1:length(fields)
                    associated_genes = m.par_ass_genes.(fields{i});
                    for j = 1:length(associated_genes)
                        body{end+1} = sprintf('\t\tsqrt(1/%d) * ( 1-corrT(R.p(%d,:),gene_data.%s.gtot) )\n', length(associated_genes), m.p.(fields{i}), m.info.genes{associated_genes(j)}); 
                    end
                end
                body{end+1} = sprintf('\t\t\t];\n\n');
                body{end+1} = sprintf('\treg = [R.lab1 * pdreg\n');
                body{end+1} = sprintf('\t\t\tR.lab1 * cr ];\n\n');
            catch
                disp(' *** no gene expression data');
                body{end+1} = sprintf('\tp_diff = ( (p-p_prev) ./ p0) / (t(end)-t(1));\n');
                body{end+1} = sprintf('\tp_diff = p_diff(1:length(p));\n\n');
                body{end+1} = sprintf('\tpdreg = [\n');
                body{end+1} = sprintf('\t\t\tp_diff(%d)\n', m.not_associated);
                body{end+1} = sprintf('\t\t\t];\n\n');
                body{end+1} = sprintf('\tR.p = [R.p,p];\n');
                body{end+1} = sprintf('\tcr =  [];\n\n');
                body{end+1} = sprintf('\treg = [ R.lab1 * pdreg\n');
                body{end+1} = sprintf('\t\t\tR.lab1 * cr ];\n\n');
            end

            body{end+1} = '%% -- weighted error: difference between model prediction and experimental data\n';
            body{end+1} = sprintf('e_data = [\n');
            for i = 1:length(m.eq.y)
                pair = m.eq.y{i};
                data = pair{2};

                body{end+1} = sprintf('\t\t(y_sim(%d,end) - data.%s.m(end)) ./ (data.%s.sd(end))\n',i,data,data);
            end
            body{end+1} = sprintf('\t\t];\n\n\n');

            body{end+1} = '%% -- regularization term\n';
            body{end+1} = sprintf('if tspan(end)>0\n\te_reg = (p - p_prev) ./ p0;\nelse\n\te_reg = [];\nend\n\\n');


            body{end+1} = '%% -- compute total error\n';
            body{end+1} = sprintf('error = [e_data; m.info.lambda_r*e_reg; reg];\n\n\n');

            % conditional
            body{end+1} = sprintf(m.conditional);
            body{end+1} = sprintf('\n');
            
            body{end+1} = '%% -- append zeros such that algorithm functions (length(error) should be at least #parameters)\n';
            body{end+1} = sprintf('if length(error)<length(p)\n\tN = length(p)-length(error);\n\terror = [error; zeros(N,1)];\nend');
        
        case 'ODE'
            body_flux = preprocess_eq(m,'flux','fluxes for ODE file');
            body_ODE = preprocess_eq(m,type,'ODEs');
            body = [body_flux '\n' body_ODE];

        otherwise
            body = preprocess_eq(m,type);
    end
end

% =========================================================================
function footer = get_footer(type)
    switch type
        case 'ODE'
            footer = '\n\ndxdt = dxdt(:);';
        otherwise
            footer = [];
    end
end

% =========================================================================
function body = preprocess_eq(m,type,varargin)
    switch type
        case 'flux'
            output_var = 'j';
            fn_type = 'j';
        case 'ODE'
            output_var = 'dxdt';
            fn_type = 'x';
        case 'observables'
            output_var = 'y';
            fn_type = 'y';
    end
    
    body{1} = [];
    
    % If there is input (u) take this into account
    if isfield(m.info, 'u')
        valid_model_fieldnames = {'s' 'j' 'p' 'u'};
        valid_model_components = {'x' 'j' 'p' 'u'};       
    else
        valid_model_fieldnames = {'s' 'j' 'p'};
        valid_model_components = {'x' 'j' 'p'};
    end
    valid_operators = {'+' '-' '*' '/' 'exp' 'power' 'if ' 'else' 'end' 'pi' '>' '<' '=' '==' ',' ';' '(' ')' '\n' '\t'};
    
    
    N = 1:length(m.eq.(fn_type));
    if ~isempty(varargin) && strcmp(varargin{1},'fluxes for ODE file')
        N(m.info.j_helper) = [];
    end
    
    
    for i = N
        switch type
            case 'observables'
                pair = m.eq.y{i};
                eq = pair{1};
            otherwise
                eq = m.eq.(fn_type){i};
        end
        
        description = m.info.(fn_type){i};
        name = description{1};
        info = description{2};
       
        % detect operators
        ind_operators = [];
        operator_list = {};
        for i_operator = 1:length(valid_operators)
            i_curr = strfind(eq,valid_operators{i_operator});
            if ~isempty(i_curr)
                operator_list = [operator_list	repmat({valid_operators{i_operator}},1,length(i_curr))];
            end
            ind_operators = [ind_operators	i_curr];
        end
        [ind_operators_sorted,i_sorted] = sort(ind_operators);
        operator_list_sorted = {};
        for j = 1:length(i_sorted)
            operator_list_sorted{j} = operator_list{i_sorted(j)};
        end        
        ind_operators = ind_operators_sorted;
        operator_list = operator_list_sorted;
        
        % detect model components
        clear mc_all
        if ~isempty(ind_operators) %combination of model components
            mc_all{1} = eq(1:ind_operators(1)-1);
            for i1 = 1:length(ind_operators)-1
                mc_all{i1+1} = eq(ind_operators(i1)+length(operator_list{i1}):ind_operators(i1+1)-1);
            end
            mc_all{end+1} = eq(ind_operators(end)+length(operator_list{end}):end);
        else                       %single model component
            mc_all{1} = eq;
        end
        

        % iterate through all included model components
        output_line = [];
        for i_mc = 1:length(mc_all)
            mc_curr = mc_all{i_mc};

            % strip white spaces from component names
            mc_curr(strfind(mc_curr,' ')) = '';
            
            % detect fieldname of model component
            clear fn mc
            for i_fn = 1:length(valid_model_fieldnames)
                if isfield(m.(valid_model_fieldnames{i_fn}),mc_curr)
                    fn = valid_model_fieldnames{i_fn};
                    mc = valid_model_components{i_fn};
                end
            end
            
            % include full description of model component (field names and corresponding index)
            if exist('fn','var') && ( isempty(varargin) || ( ~isempty(varargin) && strcmp(varargin{1},'fluxes for ODE file') && ~strcmp(fn,'j') ) )
                mc_curr = [mc '(m.' (fn) '.' mc_curr ')'];
            end

            
            % construct output line
            if ~isempty(mc_curr)
                if i_mc < length(mc_all)
                    output_line = [output_line mc_curr operator_list{i_mc}];
                else
                    output_line = [output_line mc_curr];
                end
            else
                if i_mc < length(mc_all)
                    output_line = [output_line operator_list{i_mc}];
                end
            end
        end       

            
        % include output line in body
        if isempty(varargin) %normal
            body{end+1} = ['\n\n%% ' name ': ' info '\n'];
            if strfind(output_line,'if')
                body{end+1} = sprintf('%s',output_line);
            else
                body{end+1} = sprintf('%s(%d) = %s;',output_var,i,output_line);
            end
        elseif strcmp(varargin{1},'fluxes for ODE file')
            if strfind(output_line,'if')
                body{end+1} = sprintf('\n%s;',output_line);
            else
                body{end+1} = sprintf('\n%s = %s;',name,output_line);
            end
        elseif strcmp(varargin{1},'ODEs')
            body{end+1} = ['\n\n%% [ODE] ' name ': ' info '\n'];
            body{end+1} = sprintf('%s(%d) = %s;',output_var,i,eq);
        end
    end
end