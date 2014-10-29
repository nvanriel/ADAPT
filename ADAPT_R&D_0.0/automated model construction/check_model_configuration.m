function m = check_model_configuration(m, u)

    % load data
    m.raw_data = load_raw_data(m);
    m.gene_data = load_gene_data(m);
    
    % define names
    m = feval(['initialize_model_' m.modelname],m,m.raw_data);

    % links names to indexes and creates files from this information if
    % necessary
    m = define_default_options(m); 
    
    %% test ODE files
    [t_sim1,x_sim1] = ode15s(m.info.odefile,m.info.t_tot(2:end),m.x0,m.info.ode_options,m.p_init, u, m);
    t_sim1 = t_sim1';
    x_sim1 = x_sim1';
    

    % test MEX files
    if isfield(m.info,'mexfile') && exist(func2str(m.info.mexfile),'file')
        [t_sim2,x_sim2] = feval(m.info.mexfile,m.info.t_tot(2:end),m.x0,m.p_init,u,[1e-6 1e-8 10]);
    end
    
    % test flux file & observables
    for i_t = 1:length(t_sim1)
        j_sim1(:,i_t) = feval(m.info.fluxfile,t_sim1(i_t),x_sim1(:,i_t),m.p_init,u,m)';
        y_sim1(:,i_t) = feval(m.info.observfile,t_sim1(i_t),x_sim1(:,i_t),j_sim1(:,i_t),m.p_init,u,m);
        if isfield(m.info,'mexfile') && exist(func2str(m.info.mexfile),'file')
            j_sim2(:,i_t) = feval(m.info.fluxfile,t_sim2(i_t),x_sim2(:,i_t),m.p_init,u,m)';
            y_sim2(:,i_t) = feval(m.info.observfile,t_sim2(i_t),x_sim2(:,i_t),j_sim2(:,i_t),m.p_init,u,m);
        end
    end
    
    % -- display size of simulation output components
    disp(['ODE - t: ' num2str(length(t_sim1(:,1))) ' x ' num2str(length(t_sim1(1,:)))])
    disp(['    - x: ' num2str(length(x_sim1(:,1))) ' x ' num2str(length(x_sim1(1,:)))])
    disp(['    - j: ' num2str(length(j_sim1(:,1))) ' x ' num2str(length(j_sim1(1,:)))])
    disp(['    - y: ' num2str(length(y_sim1(:,1))) ' x ' num2str(length(y_sim1(1,:)))])
    
    if isfield(m.info,'mexfile') && exist(func2str(m.info.mexfile),'file')
        disp(['MEX - t: ' num2str(length(t_sim2(:,1))) ' x ' num2str(length(t_sim2(1,:)))])
        disp(['    - x: ' num2str(length(x_sim2(:,1))) ' x ' num2str(length(x_sim2(1,:)))])
        disp(['    - j: ' num2str(length(j_sim2(:,1))) ' x ' num2str(length(j_sim2(1,:)))])
        disp(['    - y: ' num2str(length(y_sim2(:,1))) ' x ' num2str(length(y_sim2(1,:)))])
    end

    
    % -- test simulation function
    if isfield(m.info,'mexfile') && exist(func2str(m.info.mexfile),'file')
        [t_sim_MEX,x_sim_MEX,j_sim_MEX,y_sim_MEX] = simulate_model(m.info.t_tot(2:end),m.x0,m.p_init,m.p_init,u,m); %MEX
        m2 = m; m2.info = rmfield(m2.info,'mexfile');
    else
        m2 = m; 
    end
    
   % -- just for testing cost func, there has to be a more elegant way than
   % this ....
    R.lab1 = 1;
    R.lab2 = 1;
    R.p = m.p_init; 
    [D,m] = get_spline_data(m);
    data_names = fieldnames(D(1).spline_data);
    for i = 1:length(data_names)
        data_item = char(data_names(i));
        data_curr.(data_item).t = D(1).spline_data.(data_item).t(1);
        data_curr.(data_item).m = D(1).spline_data.(data_item).m(1);
        if isfield(D(1).spline_data.(data_item),'sd')
            data_curr.(data_item).sd = D(1).spline_data.(data_item).sd(1);
        end
    end
    gene_names = fieldnames(D(1).gene_spline);
    for i = 1:length(gene_names)
        gene_item = char(gene_names(i));
        gene_curr.(gene_item).t = D(1).gene_spline.(gene_item).t(1);
        gene_curr.(gene_item).abs = D(1).gene_spline.(gene_item).m(1);
        gene_curr.(gene_item).gtot = D(1).gene_spline.(gene_item).m(1:1);
        gene_curr.(gene_item).diff = D(1).gene_spline_diff.(gene_item).m(1); 
        if isfield(D(1).gene_spline.(gene_item),'sd')
            gene_curr.(gene_item).sd = D(1).gene_spline.(gene_item).sd(1);
        end
    end
    % -- test costfunction
    m.info.costfile = ['costfunc_' m.modelname];
    error = feval(m.info.costfile,m.p_init,m.p_init,m.p_init,u,m.x0,m.info.t_tot(2:end),data_curr,gene_curr,R,m);
    SSE = sum(error.^2);
end