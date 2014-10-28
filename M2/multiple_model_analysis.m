% multiple model analysis

% create working directory and add ADAPT library to path
addpath(genpath(pwd));
addpath(genpath(fullfile(pwd, '..', 'ADAPT_R&D_0.0')))
clc;

% define common values between models
common.Niter = 4;
common.Ndt = 200;
common.nmbr_of_pars = 22;

% define reference model and run ADAPT analysis
m.modelname = 'M2';
ref_modelname = m.modelname;
m.Niter = common.Niter;                        % number of iterations
m.Ndt = common.Ndt;                            % number of time samples
u = [];                                        % no input
m.info.observfile = @observables_M2;           % cost function // observables

if ~exist(['results/Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_reference_predictions/result.mat'], 'file')
    m = check_model_configuration(m, u);
    [R,m] = perform_ADAPT(m, u);
    pause(3)
    movefile(['results\Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt)], ['results\Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_reference_predictions']);
end

Ref = load(['results/Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_reference_predictions/result.mat']);

% perform a sensitivity analysis on the reference model
if ~exist('analysis/SensitivityBox.mat', 'file')
    resultfile = ['Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_reference_predictions/result.mat'];
    sensitivity_analysis(m, u, resultfile);
    pause(5)
else
    load('analysis/SensitivityBox.mat')
end
if ~exist('sensitivity_analysis.xls', 'file')
    sa_ranked(SensitivityBox, names_par, names_xj); 
end

% define target model and run ADAPT analysis
% (target model has same model topology as reference model but different data)
clear R m;
m.modelname = 'M2a';
targ_modelname = m.modelname;
m.Niter = common.Niter;                     % number of iterations
m.Ndt = common.Ndt;                         % number of time samples
u = [];                                     % no input
m.info.observfile = @observables_M2a;       % cost function // observables

cd(fullfile('..', targ_modelname));
addpath(genpath(pwd));
if ~exist(['results/Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_target_predictions/result.mat'], 'file')
    m = check_model_configuration(m, u);
    [R,m] = perform_ADAPT(m, u);
    pause(3)
    movefile(['results/Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt)], ['results/Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_target_predictions']);
end

Targ = load(['results/Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_target_predictions/result.mat']);
% define readout of interest : 
% can be either a specific state / flux in the model or a combination of
% states / fluxes
roi.type = 'x';
roi.index = 4:7;
roi.time_span = [190 200]; % in time steps

% number of parameters
nmbr_of_pars = length(names_par);

% get difference in readout between target and reference predictions
roi_ref = get_value_roi(roi, Ref.R);
roi_targ = get_value_roi(roi, Targ.R);
roi_diff_baseline = roi_ref - roi_targ;

% case 1 : observe the effect on this difference 
% when systematically substituting target predictions for reference predictions
% by running the model using all but one parameter trajectory reference predictions
% and one parameter trajectory target prediction as input.

% extract input for perturbation analysis from target predictions
load(fullfile('results', ['Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_target_predictions'], 'result.mat'));
targ_input = extract_input(R, m.Niter, 1:nmbr_of_pars);

% extract input for perturbation analysis from reference predictions
cd(fullfile('..', ref_modelname))
load(['results/Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '_reference_predictions/result.mat']);
ref_input = extract_input(R, m.Niter, 1:nmbr_of_pars);

roi_diff_subst = zeros(nmbr_of_pars,1);
sprintf('performing perturbation by substitution');
for i = 1:nmbr_of_pars
   fprintf('performing perturbation by substitution: par %d \n', i);
   id = ['_subst_par_' num2str(i)];
   inputs = ref_input;
   inputs(i,:,:) = targ_input(i,:,:);
   roi_targ = perturbation(ref_modelname, common, inputs, roi, id);
   roi_diff_subst(i) = roi_ref - roi_targ;
end

% case 2 : observe the effect on this difference when modulating
% reference parameter trajectory predictions with the target/reference
% parameter prediction ratio of a specified time frame

% obtain ratios in parameter predictions
folder_ref = ref_modelname;
folder_targ = targ_modelname; 
ratios = zeros(nmbr_of_pars,1);

if ~exist([folder_ref '/analysis/ratios.mat'], 'file')
    fprintf('determining ratios paramter trajectories target / reference \n');
    cd ..
    ratios = reldiff_all(folder_targ, folder_ref, common, roi.time_span);
    cd(folder_ref);
    save('analysis/ratios.mat', 'ratios')
else
    load('analysis/ratios.mat')
end

% do perturbation by modulation
roi_diff_mod = zeros(nmbr_of_pars,1);
for i = 1:nmbr_of_pars
    fprintf('performing perturbation by modulation: par %d \n', i);
    id = ['_mod_par_' num2str(i)];
    inputs = ref_input;
    inputs(i,:,:) = inputs(i,:,:)*ratios(i);
    roi_targ = perturbation(ref_modelname, common, inputs, roi, id);
    roi_diff_mod(i) = roi_ref - roi_targ;
end


roi_diff = [roi_diff_subst roi_diff_mod];
roi_names = {'diff_subst' 'diff_mod'};

% write to table
if ~exist('perturbation.xls', 'file');
    if verLessThan('matlab', '8.1.0')
        roi_diff_dataset = dataset({roi_diff, roi_names{:}}, 'ObsNames', names_par);
        export(roi_diff_dataset, 'XLSfile', 'perturbation');
    else
        roi_diff_table = array2table(roi_diff, 'RowNames', names_par, 'VariableNames', roi_names);
        writetable(roi_diff_table, 'perturbation.xls', 'Sheet', 1, 'WriteVariableNames', 1, 'WriteRowNames', 1);
    end
end

% in this way you can evaluate how much specific differences in parameter
% predictions can explain differences between conditions or phenotype


