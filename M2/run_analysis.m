clc;clear all
addpath(genpath(pwd))
addpath(genpath('..\ADAPT_R&D_0.0\'))

% define model specifics
m.modelname = 'M2';

m.Niter = 100;             %number of data samples
m.Ndt = 200;             %number of time samples

m.info.smooth    = 1;       %default: 1
m.info.sd_weight = 1;       %default: 1
m.info.lambda_r  = 0.1;     %default: 0.1
u = [];

m.info.observfile = @observables_M2;
m = check_model_configuration(m, u);

% perform ADAPT
[R,m] = perform_ADAPT(m, u);

% visualise results
check_for_fit;

