function [R, m] = perform_ADAPT(m, input_values)

% -- use parallel computing
if verLessThan('matlab', '8.2.0')
    if matlabpool('size') == 0;
        matlabpool;
    end
else
    poolobj = gcp('nocreate');
    if ~isempty(poolobj);
        fprintf('%d workers active\n', poolobj.NumWorkers)
    else
        parpool;
    end
end

% -- define output file name
if isfield(m,'phenotype')
    save_dir = [pwd '\results (' m.phenotype ')\Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '\'];
else
    save_dir = [pwd '\results\Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '\'];
end
if ~exist(save_dir,'dir')
    mkdir(save_dir)
end
all_files = ls(save_dir);
if ~isempty(all_files)
    for i_file = 1:length(all_files(:,1))
        if strfind(all_files(i_file,:),'.mat')
            filename_output = [save_dir all_files(i_file,:)];
        end
    end
end
if ~exist('filename_output','var')
    filename_output = [save_dir 'result.mat'];
end
    


if ~exist(filename_output,'file')
    tic    
  
    % -- load original data set
    result(1).raw_data = load_raw_data(m);
    if exist(['gene_data_' m.modelname '.mat'],'file')
        result(1).gene_data = load_gene_data(m);
    end
    
    % -- initialize model
    m = feval(['initialize_model_' m.modelname],m,result(1).raw_data);
    m = define_default_options(m);
    m.raw_data = result(1).raw_data; %temp
    if exist('R(1).gene_data', 'var')
        m.gene_data = result(1).gene_data;
    end
   
    % -- define data spline (sample raw data and interpolate to time span)
    [D,m] = get_spline_data(m);            
    fprintf('%d iterations\n', m.Niter);
    iterations_done = 0;
    % -- iterate through total number of data spline
    parfor_progress(m.Niter);
    parfor i_it = 1:m.Niter
        result = struct();
        result.raw_data = m.raw_data;
        result.t = [];
        result.spline_func = [];
        result.spline_data = [];
        result.data_sample = [];  
        result.gene_spline_func = [];
        result.gene_spline = [];
        result.gene_sample = [];
        result.p = [];                                                          %optimized parameters
        result.p_initial = [];                                                  %initial parameters
        result.x0 = [];                                                         %initial state values
        result.SSE = [];                                                        %corresponding SSE
        result.x =  [];                                                         %simulated model states
        result.j =  [];                                                         %simulated model fluxes
        result.j1 = []; result.j2 = []; result.j3 = [];  result.j4 = [];
        result.j5 = []; result.j6 = []; result.j7 = [];  result.j8 = [];
        result.j9 = []; result.j10 = [];result.jm = [];                         % result.jm = mean of flux results, reflects overall flux best
        result.y =  [];                                                         %simulated observable model outputs
        % -- optimize model for current data spline at each time sample
        result.lab1 = 10.^(2*rand-4);   % [ 10^-2 10^-4 ]
        result.lab2 = 10.^(2*rand-10);  % [ 10^-8 10^-10]
        for i_time = 2:(m.Ndt+1)
            % -- define current time segment
            t_start = m.info.t_tot(i_time-1); % for i_time == 2 --> t_start:t_end = -1000 : 0;
            t_end = m.info.t_tot(i_time);
%             t_mean = mean([t_start t_end]);
            step = (t_end - t_start)/10;
            steps = 0:step:10*step;
%             t_curr = [t_start t_mean t_end]; 
            t_curr = t_start+steps;


            % -- get data at current time point
            data_names = fieldnames(D(i_it).spline_data);
            data_curr = struct();
            for i = 1:length(data_names)
                data_item = char(data_names(i))
                data_curr.(data_item).t = D(i_it).spline_data.(data_item).t(i_time-1);
                data_curr.(data_item).m = D(i_it).spline_data.(data_item).m(i_time-1);
                if isfield(D(i_it).spline_data.(data_item),'sd')
                    data_curr.(data_item).sd = D(i_it).spline_data.(data_item).sd(i_time-1);
                end
            end
            
            % -- get gene data at current time point
            gene_names = fieldnames(D(i_it).gene_spline);
            gene_curr = struct();
            for i = 1:length(gene_names)
                gene_item = char(gene_names(i));
                gene_curr.(gene_item).t = D(i_it).gene_spline.(gene_item).t(i_time-1);
                gene_curr.(gene_item).abs = D(i_it).gene_spline.(gene_item).m(i_time-1);
                gene_curr.(gene_item).gtot = D(i_it).gene_spline.(gene_item).m(1:i_time-1);
                gene_curr.(gene_item).diff = D(i_it).gene_spline_diff.(gene_item).m(i_time-1); 
                if isfield(D(i_it).gene_spline.(gene_item),'sd')
                    gene_curr.(gene_item).sd = D(i_it).gene_spline.(gene_item).sd(i_time-1);
                end
            end
          
            % -- get (if available) input values for current time point
            if ~isempty(input_values)
                u = input_values(:,i_time, i_it);
            else u = [];
            end

            % -- perform optimization of current situation
            if i_time == 2      
                x0_curr = m.x0;
                x0_curr = refine_initial_values(data_curr, x0_curr, m);
                p_curr = 10.^(2*rand(length(m.info.p),1)-2);
                result.p_initial = p_curr;
                result.x0 = x0_curr;
                p0 = p_curr;
                p_prev = p_curr;
            else
                x0_curr = result.x(:,i_time-2);
                p0      = result.p(:,1);
                p_curr  = result.p(:,i_time-2);
                p_prev  = p_curr; 
            end
            
            % -- the optimization
            [p_est,SSE,~,~,~,~,jacobian] = lsqnonlin((m.info.costfile),p_curr,...
                                        m.info.lb,m.info.ub,m.info.lsq_options,...
                                        p_prev,p0,u,x0_curr,t_curr,data_curr,gene_curr,result,m);
                                                   
                
            % -- compute optimized model simulations
            [~,x_sim,j_sim,y_sim] = simulate_model(t_curr,x0_curr,p_est,p0,u,m);

            % -- save results to output structure
            if i_time == 2
                result.t = m.info.t_tot(2:end);
                result.spline_func = D(i_it).spline_func;
                result.spline_data = D(i_it).spline_data;
                result.data_sample = D(i_it).data_sample;    
                result.gene_spline_func = D(i_it).gene_spline_func;
                result.gene_spline = D(i_it).gene_spline;
                result.gene_sample = D(i_it).gene_sample;
            end
            

            result.p(:,i_time-1) = p_est;                                               % optimized parameters
            result.SSE(i_time-1) = SSE;                                                 % corresponding SSE
            result.x(:,i_time-1) = x_sim(:,end);                                        % simulated model states
            result.y(:,i_time-1) = y_sim(:,end);                                        % simulated observable model outputs
            result.j(:,i_time-1) = j_sim(:,end);                                        % simulated model fluxes
            result.j1(:,i_time-1) = j_sim(:,1);  result.j2(:,i_time-1) = j_sim(:,2);
            result.j3(:,i_time-1) = j_sim(:,3);  result.j4(:,i_time-1) = j_sim(:,4);
            result.j5(:,i_time-1) = j_sim(:,5);  result.j6(:,i_time-1) = j_sim(:,6);
            result.j7(:,i_time-1) = j_sim(:,7);  result.j8(:,i_time-1) = j_sim(:,8);
            result.j9(:,i_time-1) = j_sim(:,9);  result.j10(:,i_time-1) = j_sim(:,10);
            % --  mean of simulated model fluxes:        
            result.jm(:,i_time-1) = (result.j(:,i_time-1) + result.j1(:,i_time-1) + result.j2(:,i_time-1) + result.j3(:,i_time-1) + result.j4(:, i_time-1) + result.j5(:, i_time-1) + result.j6(:,i_time-1) + result.j7(:,i_time-1) + result.j8(:,i_time-1) + result.j9(:,i_time-1) + result.j10(:,i_time-1))/11;
            
            % -- track progress
            if i_time == m.Ndt+1
               iterations_done = iterations_done + 1;
               parfor_progress;
            end

        end
        % -- save intermediate results
        filename_TEMP = [save_dir 'result' num2str(i_it) '.mat'];
        save_iter(filename_TEMP, result);
    end
    % -- put all results in one data structure
    get_one(save_dir);
    % -- ADAPT has finished
    fprintf('all %d iterations completed\n', iterations_done);
    t=toc; disp(['Elapsed time: ' num2str(round(t/60)) ' min'])
    R = load(filename_output);
    R = R.R;         
    parfor_progress(0);
else
    load(filename_output)
end
