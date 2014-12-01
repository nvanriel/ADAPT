load('data_Oosterveer.mat')

C16_0                     = [11.5556 17.1852 34.3704 59.2593];
C18_1                     = [14.9466 34.1637 128.114 200.712];
C16_0_i                   = interp1(data.t2,C16_0,data.t1,'linear','extrap') ;
C18_1_i                   = interp1(data.t2,C18_1,data.t1,'linear','extrap') ;
w16                       = C16_0_i ./ (C16_0_i + C18_1_i);
w18                       = C18_1_i ./ (C16_0_i + C18_1_i);

% --
hep_DNL                 = data.DNL_16_0 .* repmat(w16,size(data.DNL_16_0,1),1) + data.DNL_18_1 .* repmat(w18,size(data.DNL_18_1,1),1);
d.hep_DNL = nanmean(hep_DNL);
d.hep_DNL_std = nanstd(hep_DNL);

hep_CE_abs              = data.hep_CE.*data.hep_mass;
d.hep_CE_abs = nanmean(hep_CE_abs);
d.hep_CE_abs_std = nanstd(hep_CE_abs);

hep_FC_abs              = data.hep_FC.*data.hep_mass;
d.hep_FC_abs = nanmean(hep_FC_abs);
d.hep_FC_abs_std = nanstd(hep_FC_abs);

hep_TG_abs              = data.hep_TG.*data.hep_mass;
d.hep_TG_abs = nanmean(hep_TG_abs);
d.hep_TG_abs_std = nanstd(hep_TG_abs);

hep_CE_rel              = data.hep_CE;
d.hep_CE_rel = nanmean(hep_CE_rel);
d.hep_CE_rel_std = nanstd(hep_CE_rel);

hep_FC_rel              = data.hep_FC;
d.hep_FC_rel = nanmean(hep_FC_rel);
d.hep_FC_rel_std = nanstd(hep_FC_rel);

hep_TG_rel              = data.hep_TG;
d.hep_TG_rel = nanmean(hep_TG_rel);
d.hep_TG_rel_std = nanstd(hep_TG_rel);

hep_mass                = data.hep_mass;
d.hep_mass = nanmean(hep_mass);
d.hep_mass_std = nanstd(hep_mass);

plasma_FFA              = data.FFA;
d.plasma_FFA = nanmean(plasma_FFA);
d.plasma_FFA_std = nanstd(plasma_FFA);

plasma_TG               = data.plasma_TG;
d.plasma_TG = nanmean(plasma_TG);
d.plasma_TG_std = nanstd(plasma_TG);

VLDL_clearance          = data.VLDL_clearance ./ mean(data.VLDL_clearance(:,1));
d.VLDL_clearance = nanmean(VLDL_clearance);
d.VLDL_clearance_std = nanstd(VLDL_clearance);

VLDL_diameter           = data.VLDL_diameter;
d.VLDL_diameter = nanmean(VLDL_diameter);
d.VLDL_diameter_std = nanstd(VLDL_diameter);

VLDL_TG_C_ratio         = data.VLDL_TG ./ data.VLDL_CE;
d.VLDL_TG_C_ratio = nanmean(VLDL_TG_C_ratio);
d.VLDL_TG_C_ratio_std = nanstd(VLDL_TG_C_ratio);

VLDL_production         = data.VLDL_production;
d.VLDL_production = nanmean(VLDL_production);
d.VLDL_production_std = nanstd(VLDL_production);

% --

d.plasma_TG_FPLC          = data.plasma_TG_FPLC;
d.plasma_TG_FPLC_std      = sqrt(interp1(data.t2,nanstd(data.plasma_TG).^2,data.t1,'linear'));
d.plasma_TG_FPLC_std(end) = d.plasma_TG_FPLC_std(end-1);

d.plasma_TC_FPLC          = data.plasma_C_FPLC;
d.plasma_TC_FPLC_std      = sqrt(interp1([0 336],[137.6 302.7].^2,data.t1,'linear'));  % estimated from Grefhorst 2012 et al. Atherosclerosis
d.plasma_TC_FPLC_std(end) = d.plasma_TC_FPLC_std(end-1);

d.plasma_C_HDL_FPLC       = data.plasma_C_HDL_FPLC;
d.plasma_C_HDL_FPLC_std   = (d.plasma_C_HDL_FPLC./d.plasma_TC_FPLC) .* d.plasma_TC_FPLC_std;

d.plasma_C_HDL_FPLC_2 = d.plasma_C_HDL_FPLC ./ d.plasma_TC_FPLC;
d.plasma_C_HDL_FPLC_2_std = d.plasma_C_HDL_FPLC_std;

d.hep_SRB1                = data.hep_SRB1';
d.hep_SRB1_std            = data.hep_SRB1_std';

d.t1                      = data.t1;
d.t2                      = data.t2;

% Xie
bodymass                  = 25e-3;

mwFC                      = 386.7;      % molecular weight of FC [g  / mol], Teerlink et al.

d.hep_HDL_CE_upt          = ( bodymass * 1e6 * 44.8 * 1e-3) / (24 * mwFC);    % umol/h
d.hep_HDL_CE_upt_std      = ( bodymass * 1e6 * 6.79 * 1e-3) / (24 * mwFC);    % umol/h