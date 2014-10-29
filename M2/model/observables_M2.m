function y = observables_M2(t,x,j,p,u,m)

% hep_TG: hepatic TG
y(1) = x(m.s.hep_TG_ndnl_cyt)+x(m.s.hep_TG_ndnl_ER)+x(m.s.hep_TG_dnl_cyt)+x(m.s.hep_TG_dnl_ER);

% hep_CE: hepatic CE
y(2) = x(m.s.hep_CE_cyt)+x(m.s.hep_CE_ER);

% hep_FC: hepatic FC
y(3) = x(m.s.hep_FC);

% pl_TC: plasma total C
y(4) = x(m.s.pl_VLDL_C)+x(m.s.pl_HDL_C);

% pl_HDL_C: plasma HDL-C
y(5) = x(m.s.pl_HDL_C);

% pl_VLDL_TG: plasma TG
y(6) = x(m.s.pl_VLDL_TG_ndnl) + x(m.s.pl_VLDL_TG_dnl);

% pl_FFA: plasma FFA
y(7) = x(m.s.pl_FFA);

% VLDL_TG_C_ratio: VLDL TG:C ratio
y(8) = j(m.j.TG_count)/j(m.j.CE_count);

% VLDL_diameter: VLDL diameter
y(9) = 2*(j(m.j.core_radius)+m.c.rs);

% VLDL_TG_production: VLDL production
y(10) = j(m.j.jVLDL_TG_ndnl_synt)+j(m.j.jVLDL_TG_dnl_synt);

% VLDL_clearance: VLDL catabolic rate
% y(11) = p(m.p.k_upt_hep);

% hep_DNL: de novo lipogenesis
y(11) = (x(m.s.hep_TG_dnl_cyt)+x(m.s.hep_TG_dnl_ER))/(x(m.s.hep_TG_ndnl_cyt)+x(m.s.hep_TG_ndnl_ER)+x(m.s.hep_TG_dnl_cyt)+x(m.s.hep_TG_dnl_ER));

% jTG_Oxi: hepatic fatty acid oxidation
y(12) = j(m.j.jTG_dnl_cat_cyt) + j(m.j.jTG_ndnl_cat_cyt);

% hepTGuptake: hepatic TG uptake (Olivecrona)
y(13) = (p(m.p.k_upt_hep) + p(m.p.k_TG_lip_hep))/(p(m.p.k_upt_hep) + p(m.p.k_TG_lip_hep) + p(m.p.k_upt_per) + p(m.p.k_TG_lip_per));


