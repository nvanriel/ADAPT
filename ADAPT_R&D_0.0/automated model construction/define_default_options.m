function m = define_default_options(m)

    %% INDICES OF MODEL COMPONENTS
    model_components = {'j' 'p' 'y'};
    for i_m = 1:length(model_components)
        fn = model_components{i_m};
        for i_x = 1:length(m.info.(fn))
            item = m.info.(fn){i_x};
            m.(fn).(char(item{1})) = i_x;
        end
    end
    for i_x = 1:length(m.info.x)
        item = m.info.x{i_x};
        m.s.(char(item{1})) = i_x;
    end

   if isfield(m.info, 'u')
        for i_x = 1:length(m.info.u)
            item = m.info.u{i_x};
            m.u.(char(item{1})) = i_x;
        end
   end
    
    
    %% GENERATE MODEL FILES (or use custom files)
    % model fluxes description
    if ~isfield(m.info,'fluxfile')
        m.info.fluxfile = generate_model_files(m,'flux');
    end
    
    % ODE model description
    if ~isfield(m.info,'odefile')
        m.info.odefile = generate_model_files(m,'ODE');
    end
        
    % observable description (model-data pairs)
    if ~isfield(m.info,'observfile')
        m.info.observfile = generate_model_files(m,'observables');
    end
    
    % cost function
    if ~isfield(m.info,'costfile')
        m.info.costfile = generate_model_files(m,'costfunc');
    end
    
    % MEX (matlab executable) model description
    try
        m.info.mexfile = generate_model_files(m,'MEX');
    catch
        disp(' *** unable to compile MEX file')
    end
    
    
%     addpath(genpath(pwd))
    


    %% SIMULATION AND OPTIMIZATION OPTIONS
    % simulated time span
    m.info.t_dt  = m.info.t_max/(m.Ndt-1);
    m.info.t_tot = [-1000 0:m.info.t_dt:m.info.t_max];
    
    % ode solver options
    if ~isfield(m.info,'ode_options')
        m.info.ode_options = odeset('RelTol',1e-6,'AbsTol',1e-6);
    end
    
    % lsqnonlin options
    if ~isfield(m.info,'lsq_options')
        m.info.lsq_options = optimset('Display','off','TolX',1e-8,'TolFun',1e-8,'MaxIter',1e3,'MaxFunEvals',1e5);
    end
    
    % regularization weight
    if ~isfield(m.info,'lambda_r')
        m.info.lambda_r = 0.1;
    end
    
    % lower bound of parameters during optimization
    if ~isfield(m.info,'lb')
        m.info.lb = zeros(length(m.p_init),1);
    end
    
    % upper bound of parameters during optimization
    if ~isfield(m.info,'ub')
        m.info.ub = [];
    end
end