% Sensitivity Analysis
% modelname for input and simulation need to be the same

function sensitivity_analysis(m, u, resultfile)

dp = 1.0001;
if ~isempty(u)
    m = check_model_configuration(m, u(:,1,1));
else
    m = check_model_configuration(m, u);
end

R(1).raw_data = load_raw_data(m);
m = feval(['initialize_model_' m.modelname],m,R(1).raw_data);
m = define_default_options(m);
m.raw_data = R(1).raw_data;

% load results
load(['results/', resultfile]);

SensitivityBox = zeros(m.Niter, m.Ndt, length(m.info.p), length(m.info.x)+length(m.info.j)-length(m.info.j_helper));
% for iter
dispstat('', 'init');
dispstat('iteration : ', 'keepthis');
for iter = 1:m.Niter
    dispstat(num2str(iter))
    % for time
    for toi = 1:m.Ndt

        % for all parameters
        % since the sensitivity analysis deals with steady states, initial
        % values for states are not that important
        x0 = ones(1,length(R(1).x(:,1))); 
        p_ref = R(iter).p(:,toi);

        % obtain reference values
        % sim_results = [t x j y]
        % take input into account if available
        if ~isempty(u)
            us = u(:,toi,iter);
        else
            us = [];
        end
        [sim_t, ss_x, ss_j] = simulate_model([0 10000], x0, p_ref, [], us, m);

        p_ref = p_ref';
        coefs_x = zeros(length(x0), length(p_ref));
        % for all states 
        for i = 1:length(p_ref)
            if i ==1
                p_temp = [p_ref(i)*dp p_ref(i+1:end)];
                [t_temp, ss_x_temp] = simulate_model([0 10000], x0,p_temp , [], us, m);
            else
                p_temp = [p_ref(1:(i-1)) p_ref(i)*dp p_ref(i+1:end)];
                [t_temp, ss_x_temp] = simulate_model([0 10000], x0,p_temp, [], us, m);

            end
            % store control coefficients
            coefs_x(:,i) = ((ss_x_temp(:,end) - ss_x(:,end))./(ss_x(:,end)))*(1/0.0001);
        end

        % now parameters on rows and states on columns
        coefs_x = coefs_x';

        % for all fluxes
        coefs_j = zeros(length(ss_j(:,1)), length(p_ref));
        for i = 1:length(p_ref)
            if i ==1
                p_temp = [p_ref(i)*dp p_ref(i+1:end)];
                [t_temp, ss_x_temp, ss_j_temp] = simulate_model([0 10000], x0,p_temp , [], us, m);
            else
                p_temp = [p_ref(1:(i-1)) p_ref(i)*dp p_ref(i+1:end)];
                [t_temp, ss_x_temp, ss_j_temp] = simulate_model([0 10000], x0,p_temp, [], us, m);
            end
            % store control coefficients
            coefs_j(:,i) = ((ss_j_temp(:,end)- ss_j(:,end))./(ss_j(:,end)))*(1/0.0001);
        end

        % remove helper functions
        newlength = length(coefs_j(:,1)) - length(m.info.j_helper);
        coefs_j = coefs_j(1:newlength, :);

        % now parameters on rows and fluxes on columns
        coefs_j = coefs_j';
        SensitivityBox(iter, toi, :, :) = [coefs_x coefs_j];
    end
end


% names
names_par = fields(m.p);
state_names = fields(m.s);
flux_names = fields(m.j);
flux_names = flux_names(1:newlength);
names_xj = [state_names ; flux_names];
% save the results
if ~exist([pwd 'analysis'], 'dir')
    mkdir('analysis');
end
save('analysis/SensitivityBox.mat', 'SensitivityBox', 'names_par', 'names_xj');
end

