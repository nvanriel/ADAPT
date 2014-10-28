
% check for ok fit
set(0,'DefaultFigureWindowStyle','docked')
set(0,'DefaultAxesFontSize',12)
iters = 100;

% get model simulation results
R = load(['results/Niter=' num2str(iters) ', Ndt=200/result.mat']);
time = 1:200; time = time*504/200;

raw = R.R(1).raw_data;

% hep TG
figure(); hold on;
hep_TG = extract_meta_m(R.R, iters, 'x', 4:7, 0);
fig_raw(time, hep_TG, raw.hep_TG, raw.hep_TG.t)

% hep FC
figure(); hold on;
hep_FC = extract_meta_m(R.R, iters, 'x', 1, 0);
fig_raw(time, hep_FC, raw.hep_FC, raw.hep_FC.t)

% hep CE
figure(); hold on;
hep_CE = extract_meta_m(R.R, iters, 'x', 2:3, 0);
fig_raw(time, hep_CE, raw.hep_CE, raw.hep_CE.t);

% plasma FFA
figure(); hold on;
plasma_FFA = extract_meta_m(R.R, iters, 'x', 12, 0);
fig_raw(time, plasma_FFA, raw.pl_FFA, raw.pl_FFA.t);

% plasma TG
figure(); hold on;
plasma_TG = extract_meta_m(R.R, iters, 'x', 8:9, 0);
fig_raw(time, plasma_TG, raw.pl_VLDL_TG, raw.pl_VLDL_TG.t);

% plasma TC
figure(); hold on;
plasma_TC = extract_meta_m(R.R, iters, 'x', 10:11, 0);
fig_raw(time, plasma_TC, raw.pl_TC, raw.pl_TC.t);

% plasma HDL C
figure(); hold on;
plasma_HDL_C = extract_meta_m(R.R, iters, 'x', 11, 0);
fig_raw(time, plasma_HDL_C, raw.pl_HDL_C, raw.pl_HDL_C.t);

% plasma TG/C - ratio
figure(); hold on;
VLDL_TG_C_ratio = extract_meta_m(R.R, iters, 'y', 8, 0);
fig_raw(time, VLDL_TG_C_ratio, raw.VLDL_TG_C_ratio, raw.VLDL_TG_C_ratio.t);

% VLDL - production
figure(); hold on;
VLDL_production = extract_meta_m(R.R, iters, 'y', 10, 0);
fig_raw(time, VLDL_production, raw.VLDL_TG_production, raw.VLDL_TG_production.t);

% VLDL - clearance
% figure(); hold on;
% VLDL_clearance = extract_meta_m(R.R, iters, 'y', 11, 0);
% fig_raw(time, VLDL_clearance, raw.VLDL_clearance, raw.VLDL_clearance.t);

% VLDL - diameter
figure(); hold on;
VLDL_diameter = extract_meta_m(R.R, iters, 'y', 9, 0);
fig_raw(time, VLDL_diameter, raw.VLDL_diameter, raw.VLDL_diameter.t);

% DNL 
figure(); hold on;
DNL = extract_meta_m(R.R, iters, 'y', 11, 0);
fig_raw(time, DNL, raw.hep_DNL, raw.hep_DNL.t);

% oxi
figure(); hold on;
oxi = extract_meta_m(R.R, iters, 'y', 12, 0);
fig_raw(time, oxi, raw.jTG_Oxi, raw.jTG_Oxi.t);

% TG peripheral clearance
figure(); hold on;
peri = extract_meta_m(R.R, iters, 'j', [14 16 17 19],0);
fig_vararg(time, peri);

% TG hepatic recycling
figure(); hold on;
hep_rec = extract_meta_m(R.R, iters, 'j', [15 18 21 22],0);
fig_vararg(time, hep_rec);

% Predicted VLDL-TG FCR
figure(); hold on;
k_TG_FCR = extract_meta_m(R.R, iters, 'p', 11:14,0);
fig_vararg(time, k_TG_FCR);

% Clearance pars
% figure();
% subplot(2,2,1);hold on;
% k_per_lip = extract_meta_m(R.R, iters, 'p', 11, 0);
% fig_vararg(time, k_per_lip)
% subplot(2,2,2); hold on;
% k_per_upt = extract_meta_m(R.R, iters, 'p', 12, 0);
% fig_vararg(time, k_per_upt)
% subplot(2,2,3); hold on;
% k_hep_lip = extract_meta_m(R.R, iters, 'p', 13, 0);
% fig_vararg(time, k_hep_lip)
% subplot(2,2,4); hold on;
% k_hep_upt = extract_meta_m(R.R, iters, 'p', 14, 0);
% fig_vararg(time, k_hep_upt);