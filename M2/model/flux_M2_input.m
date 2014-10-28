function j = flux_M2_input(t,x,p,u,m)


% jFC_synt: hepatic de novo FC synthesis 
j(1) = u(m.u.k_FC_synt);

% jFC_cat: free cholesterol catabolism
j(2) = u(m.u.k_FC_cat)*x(m.s.hep_FC);

% jFC_conv_CE_cyt: hepatic conversion of FC to CE (cytosol)
j(3) = u(m.u.k_FC_conv_CE_cyt)*x(m.s.hep_FC);

% jFC_conv_CE_ER: hepatic conversion of FC to CE (ER)
j(4) = u(m.u.k_FC_conv_CE_ER)*x(m.s.hep_FC);

% jCE_conv_FC_cyt: hepatic conversion of CE to FC (cytosol)
j(5) = u(m.u.k_CE_conv_FC_cyt)*x(m.s.hep_CE_cyt);

% jCE_conv_FC_ER: hepatic conversion of CE to FC (ER)
j(6) = u(m.u.k_CE_conv_FC_ER)*x(m.s.hep_CE_ER);

% jTG_dnl_synt_cyt: hepatic de novo TG synthesis (cytosol)
j(7) = u(m.u.k_TG_dnl_synt_cyt);

% jTG_ndnl_cat_cyt: hepatic non de novo TG catabolism (cytosol)
j(8) = u(m.u.k_TG_cat_cyt)*x(m.s.hep_TG_ndnl_cyt);

% jTG_dnl_cat_cyt: hepatic de novo TG catabolism (cytosol)
j(9) = u(m.u.k_TG_cat_cyt)*x(m.s.hep_TG_dnl_cyt);

% jTG_ndnl_ER_to_cyt: hepatic non de novo TG transport (ER to cytosol)
j(10) = u(m.u.k_TG_ER_to_cyt)*x(m.s.hep_TG_ndnl_ER);

% jTG_dnl_ER_to_cyt: hepatic de novo TG transport (ER to cytosol)
j(11) = u(m.u.k_TG_ER_to_cyt)*x(m.s.hep_TG_dnl_ER);

% jTG_ndnl_cyt_to_ER: hepatic non de novo TG transport (cytosol to ER)
j(12) = u(m.u.k_TG_cyt_to_ER)*x(m.s.hep_TG_ndnl_cyt);

% jTG_dnl_cyt_to_ER: hepatic de novo TG transport (cytosol to ER)
j(13) = u(m.u.k_TG_cyt_to_ER)*x(m.s.hep_TG_dnl_cyt);

% jTG_lip_per_ndnl: peripheral TG uptake (lipolysis)
j(14) = u(m.u.k_TG_lip_per)*x(m.s.pl_VLDL_TG_ndnl);

% jTG_lip_hep_ndnl: hepatic TG uptake (lipolysis)
j(15) = u(m.u.k_TG_lip_hep)*x(m.s.pl_VLDL_TG_ndnl);

% jTG_upt_per_ndnl: peripheral TG uptake (whole particle uptake)
j(16) = u(m.u.k_upt_per)*x(m.s.pl_VLDL_TG_ndnl);

% jTG_lip_per_dnl: peripheral TG uptake (lipolysis)
j(17) = u(m.u.k_TG_lip_per)*x(m.s.pl_VLDL_TG_dnl);

% jTG_lip_hep_dnl: hepatic TG uptake (lipolysis)
j(18) = u(m.u.k_TG_lip_hep)*x(m.s.pl_VLDL_TG_dnl);

% jTG_upt_per_dnl: peripheral TG uptake (whole particle uptake)
j(19) = u(m.u.k_upt_per)*x(m.s.pl_VLDL_TG_dnl);

% jCE_upt_per: peripheral CE uptake (whole particle uptake)
j(20) = u(m.u.k_upt_per)*x(m.s.pl_VLDL_C);

% jTG_upt_hep_ndnl: hepatic TG uptake (whole particle uptake)
j(21) = u(m.u.k_upt_hep)*x(m.s.pl_VLDL_TG_ndnl);

% jTG_upt_hep_dnl: hepatic TG uptake (whole particle uptake)
j(22) = u(m.u.k_upt_hep)*x(m.s.pl_VLDL_TG_dnl);

% jCE_upt_hep: hepatic CE uptake (whole particle uptake)
j(23) = u(m.u.k_upt_hep)*x(m.s.pl_VLDL_C);

% jVLDL_TG_ndnl_synt: hepatic non de novo VLDL-TG secretion
j(24) = u(m.u.k_VLDL_TG_synt)*x(m.s.hep_TG_ndnl_ER);

% jVLDL_TG_dnl_synt: hepatic de novo VLDL-TG secretion
j(25) = u(m.u.k_VLDL_TG_synt)*x(m.s.hep_TG_dnl_ER);

% jVLDL_CE_synt: hepatic VLDL-C secretion
j(26) = u(m.u.k_VLDL_CE_synt)*x(m.s.hep_CE_ER);

% jCE_for_HDL: peripheral C efflux to HDL
j(27) = u(m.u.k_CE_for_HDL);

% jCE_upt_HDL: hepatic HDL-C uptake
j(28) = u(m.u.k_CE_upt_HDL)*x(m.s.pl_HDL_C);

% jFFA_upt: hepatic FFA uptake
j(29) = u(m.u.k_FFA_upt)*x(m.s.pl_FFA);

% jFFA_secr: net FFA secretion to plasma
j(30) = u(m.u.k_FFA_secr);

% jApoB_prod: hepatic ApoB secretion
j(31) = u(m.u.k_ApoB_prod);

% jTG_dnl_synt_ER: hepatic TG synthesis (ER)
j(32) = u(m.u.k_TG_dnl_synt_ER);

% ApoB_count: number of ApoB molecules [helper function]
j(33) = j(m.j.jApoB_prod)*m.c.Navg*1e-6;

% TG_count: number of TG molecules [helper function]
j(34) = ((j(m.j.jVLDL_TG_ndnl_synt)+j(m.j.jVLDL_TG_dnl_synt))*m.c.Navg*1e-6)/j(m.j.ApoB_count);

% CE_count: number of CE molecules [helper function]
j(35) = ((j(m.j.jVLDL_CE_synt))*m.c.Navg*1e-6)/j(m.j.ApoB_count);

% core_volume: core volume of lipoprotein [helper function]
j(36) = ((j(m.j.TG_count)*m.c.mvTG)+(j(m.j.CE_count)*m.c.mvCE))*(1e21/m.c.Navg);

% core_radius: core radius of lipoprotein [helper function]
j(37) = power((3*j(m.j.core_volume))/(4*pi),1/3);