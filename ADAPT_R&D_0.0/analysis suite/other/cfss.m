function  cfss(modelname, observ,  var_index, type)
%check for steady state

% prelude 
addpath(genpath(pwd))

m.Niter = 1;    %number of data samples
m.Ndt = 3;      %number of time samples % anything goes as long as >= 3

m.info.smooth    = 1;    %default: 1
m.info.sd_weight = 1;    %default: 1
m.info.lambda_r  = 0.1;  %default: 0.1

m.modelname = modelname;
m.info.observfile = observ;
u = [];
m = check_model_configuration(m, u);

R(1).raw_data = load_raw_data(m);
m = feval(['initialize_model_' m.modelname],m,R(1).raw_data);
m = define_default_options(m);
m.raw_data = R(1).raw_data;

% random pars and initial states
p_ref = rand(1,length(m.info.p))*10;
x0 = rand(1,length(m.info.x));

% simulate model
[sim_t, ss_x, ss_j] = simulate_model([0 10], x0, p_ref, [], u, m);
figure()
if type == 'x'
    plot(sim_t, ss_x(var_index,:))
elseif type == 'j'
    plot(sim_t, ss_j(var_index,:))
else
    fprintf('unrecognized type')

end

