% get important figures that look like those in the original paper


%% load data
Ry = load('results/Niter=100, Ndt=200/result.mat');


set(0,'DefaultFigureWindowStyle','docked')
set(0,'DefaultAxesFontSize',11)
time = 1:200;
time = time*5.04/2;
iters = 100;
%%
% VLDL TG production - catabolism (lip + upt)
VLDL_TG_prod = extract_meta_m(Ry.R, iters, 'jm', [24 25], 0);
VLDL_TG_perupt = extract_meta_m(Ry.R, iters, 'jm', [14 16 17 19],0);

VLDL_TG_prod_temp = make_temp(Ry.R, iters, 200, 'jm', [24 25]);
VLDL_TG_perupt_temp = make_temp(Ry.R, iters, 200, 'jm', [14 16 17 19]);
VLDL_TG_hepupt_temp = make_temp(Ry.R, iters, 200, 'jm', [15 18 21 22]);
VLDL_TG_net_temp = VLDL_TG_prod_temp - VLDL_TG_perupt_temp - VLDL_TG_hepupt_temp;
VLDL_TG_net = extract_meta_m(Ry.R, iters, 'jm', 1, VLDL_TG_net_temp);

figure()
subplot(2,1,1); hold on;
raw.VLDL_TG_production = Ry.R(1).raw_data.VLDL_TG_production;
fig_raw(time, VLDL_TG_prod, raw.VLDL_TG_production, raw.VLDL_TG_production.t);
subplot(2,1,2); hold on;
fig_vararg(time, VLDL_TG_perupt);

figure(); 
subplot(2,1,1);hold on;
raw.plasma_TG = Ry.R(1).raw_data.pl_VLDL_TG;
plasma_TG = extract_meta_m(Ry.R, iters, 'x', 8:9, 0);
fig_raw(time, plasma_TG, raw.plasma_TG, raw.plasma_TG.t);
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
xlabel('Treatment period (days)');
ylabel('VLDL TG (\mumol)');
title('VLDL TG');
legend('off');
subplot(2,1,2);hold on;
fig_vararg(time, VLDL_TG_net);
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
xlabel('Treatment period (days)');
ylabel('TG flux (\mumol/h)');
title('VLDL TG production - catabolism')
legend('off');

% Sum of input and output fluxes in the liver
DNL = extract_meta_m(Ry.R, iters, 'jm', [7 32], 0);
FFA = extract_meta_m(Ry.R, iters, 'jm', 29, 0);
LIP = extract_meta_m(Ry.R, iters, 'jm', [15 18 21 22],0);
FFA = FFA/3;
FAO = extract_meta_m(Ry.R, iters, 'jm', [8 9], 0);

DNLt = make_temp(Ry.R, iters, 200, 'jm', [7 32]);
FFAt = make_temp(Ry.R, iters, 200, 'jm', 29);
FFAt = FFAt/3;
LIPt = make_temp(Ry.R, iters, 200, 'jm', [15 18 21 22]);
INt = DNLt+FFAt+LIPt;
IN = extract_meta_m(Ry.R, iters, 'jm', 1, INt);

FAOt = make_temp(Ry.R, iters, 200, 'jm', [8 9]);
OUTt = VLDL_TG_prod_temp + FAOt;
OUT = extract_meta_m(Ry.R, iters, 'jm', 1, OUTt);

NETt = INt-OUTt;
NET = extract_meta_m(Ry.R, iters, 'jm', 1, NETt);



figure(); 
subplot(2,2,1); hold on;
fig_vararg(time, IN)
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
ylabel('TG flux (\mumol/h)');
xlabel('Treatment period (days)');
title('Sum of input fluxes')
legend('off');
subplot(2,2,2); hold on;
fig_vararg(time, OUT)
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
ylabel('TG flux (\mumol/h)');
xlabel('Treatment period (days)');
title('Sum of output fluxes');
legend('off');
subplot(2,2,3); hold on;
fig_vararg(time, NET)
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
ylabel('net TG flux (\mumol/h)');
xlabel('Treatment period (days)');
title('Input - output');
legend('off');
subplot(2,2,4); hold on;
% Fractional contribution of DNL, FFA and LIP
fDNLt = DNLt./INt; 
fFFAt = FFAt./INt;
fLIPt = LIPt./INt;

fDNL = extract_meta_m(Ry.R, iters, 'f', 1, fDNLt);
fFFA = extract_meta_m(Ry.R, iters, 'f', 1, fFFAt);
fLIP = extract_meta_m(Ry.R, iters, 'f', 1, fLIPt);
fig_vararg(time, fDNL, fFFA, fLIP);
ylabel('Fraction', 'FontWeight', 'bold');
xlabel('Treatment period (days)', 'FontWeight', 'bold');
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
title('Fractional contribution of input fluxes');
legend('de novo lipogenesis', 'NEFA uptake', 'TG reuptake' , 'Location', 'Best');
legend(gca, 'boxon');


figure()
subplot(2,2,1); hold on;
fig_vararg(time, FFA, DNL, LIP)
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
ylabel('TG flux (\mumol/h)');
xlabel('Treatment period (days)');
title('Input fluxes')
legend('NEFA', 'DNL','reuptake', 'Location', 'NorthWest');
legend(gca, 'boxoff')
subplot(2,2,2); hold on;
fig_vararg(time, FAO, VLDL_TG_prod)
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
ylabel('TG flux (\mumol/h)');
xlabel('Treatment period (days)');
title('Output fluxes');
legend('FAO', 'VLDL TG prod', 'Location', 'NorthWest');
legend(gca, 'boxoff')
subplot(2,2,3); hold on;
fig_vararg(time, NET)
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
ylabel('net TG flux (\mumol/h)');
xlabel('Treatment period (days)');
title('Input - output');
legend('off');
subplot(2,2,4); hold on;
% Fractional contribution of DNL, FFA and LIP
fig_vararg(time, fDNL, fFFA, fLIP);
ylabel('Fraction', 'FontWeight', 'bold');
xlabel('Treatment period (days)', 'FontWeight', 'bold');
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
title('Fractional contribution of input fluxes');
legend('de novo lipogenesis', 'NEFA uptake' ,'TG reuptake', 'Location', 'Best');

% mm
DNLplust = make_temp(Ry.R, iters, 200, 'jm', [7 18 22 32]);
FFAplust = make_temp(Ry.R, iters, 200, 'jm', [15 21]);
FFAplust = FFAplust + FFAt;
fDNLplust = DNLplust./INt;
fFFAplust = FFAplust./INt;
fDNLplus = extract_meta_m(Ry.R, iters, 'jm', 1, fDNLplust);
fFFAplus = extract_meta_m(Ry.R, iters, 'jm', 1, fFFAplust);
figure(); hold on;
fig_vararg(time, fDNLplus, fFFAplus);
ylabel('Fraction', 'FontWeight', 'bold');
xlabel('Treatment period (days)', 'FontWeight', 'bold');
set(gca, 'XTick', 0:3*24:21*24, 'XTickLabel', {'0' '3' '6' '9' '12' '15' '18' '21'}, 'FontWeight', 'bold');
title('Fractional contribution of input fluxes');
legend('de novo lipogenesis', 'NEFA uptake', 'Location', 'Best');


