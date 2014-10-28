function dxdt = ODE_M2(t,x,p,u,m)

jFC_synt = p(m.p.k_FC_synt);
jFC_cat = p(m.p.k_FC_cat)*x(m.s.hep_FC);
jFC_conv_CE_cyt = p(m.p.k_FC_conv_CE_cyt)*x(m.s.hep_FC);
jFC_conv_CE_ER = p(m.p.k_FC_conv_CE_ER)*x(m.s.hep_FC);
jCE_conv_FC_cyt = p(m.p.k_CE_conv_FC_cyt)*x(m.s.hep_CE_cyt);
jCE_conv_FC_ER = p(m.p.k_CE_conv_FC_ER)*x(m.s.hep_CE_ER);
jTG_dnl_synt_cyt = p(m.p.k_TG_dnl_synt_cyt);
jTG_ndnl_cat_cyt = p(m.p.k_TG_cat_cyt)*x(m.s.hep_TG_ndnl_cyt);
jTG_dnl_cat_cyt = p(m.p.k_TG_cat_cyt)*x(m.s.hep_TG_dnl_cyt);
jTG_ndnl_ER_to_cyt = p(m.p.k_TG_ER_to_cyt)*x(m.s.hep_TG_ndnl_ER);
jTG_dnl_ER_to_cyt = p(m.p.k_TG_ER_to_cyt)*x(m.s.hep_TG_dnl_ER);
jTG_ndnl_cyt_to_ER = p(m.p.k_TG_cyt_to_ER)*x(m.s.hep_TG_ndnl_cyt);
jTG_dnl_cyt_to_ER = p(m.p.k_TG_cyt_to_ER)*x(m.s.hep_TG_dnl_cyt);
jTG_lip_per_ndnl = p(m.p.k_TG_lip_per)*x(m.s.pl_VLDL_TG_ndnl);
jTG_lip_hep_ndnl = p(m.p.k_TG_lip_hep)*x(m.s.pl_VLDL_TG_ndnl);
jTG_upt_per_ndnl = p(m.p.k_upt_per)*x(m.s.pl_VLDL_TG_ndnl);
jTG_lip_per_dnl = p(m.p.k_TG_lip_per)*x(m.s.pl_VLDL_TG_dnl);
jTG_lip_hep_dnl = p(m.p.k_TG_lip_hep)*x(m.s.pl_VLDL_TG_dnl);
jTG_upt_per_dnl = p(m.p.k_upt_per)*x(m.s.pl_VLDL_TG_dnl);
jCE_upt_per = p(m.p.k_upt_per)*x(m.s.pl_VLDL_C);
jTG_upt_hep_ndnl = p(m.p.k_upt_hep)*x(m.s.pl_VLDL_TG_ndnl);
jTG_upt_hep_dnl = p(m.p.k_upt_hep)*x(m.s.pl_VLDL_TG_dnl);
jCE_upt_hep = p(m.p.k_upt_hep)*x(m.s.pl_VLDL_C);
jVLDL_TG_ndnl_synt = p(m.p.k_VLDL_TG_synt)*x(m.s.hep_TG_ndnl_ER);
jVLDL_TG_dnl_synt = p(m.p.k_VLDL_TG_synt)*x(m.s.hep_TG_dnl_ER);
jVLDL_CE_synt = p(m.p.k_VLDL_CE_synt)*x(m.s.hep_CE_ER);
jCE_for_HDL = p(m.p.k_CE_for_HDL);
jCE_upt_HDL = p(m.p.k_CE_upt_HDL)*x(m.s.pl_HDL_C);
jFFA_upt = p(m.p.k_FFA_upt)*x(m.s.pl_FFA);
jFFA_secr = p(m.p.k_FFA_secr);
jApoB_prod = p(m.p.k_ApoB_prod);
jTG_dnl_synt_ER = p(m.p.k_TG_dnl_synt_ER);


% [ODE] hep_FC: hepatic free cholesterol
dxdt(1) = jFC_synt + jCE_conv_FC_cyt + jCE_conv_FC_ER - jFC_conv_CE_cyt - jFC_conv_CE_ER - jFC_cat;

% [ODE] hep_CE_cyt: hepatic CE (cytosol)
dxdt(2) = jCE_upt_HDL + jFC_conv_CE_cyt - jCE_conv_FC_cyt + jCE_upt_hep;

% [ODE] hep_CE_ER: hepatic CE (ER)
dxdt(3) = jFC_conv_CE_ER - jCE_conv_FC_ER - jVLDL_CE_synt;

% [ODE] hep_TG_ndnl_cyt: hepatic non de novo TG (cytosol)
dxdt(4) = jTG_ndnl_ER_to_cyt - jTG_ndnl_cyt_to_ER - jTG_ndnl_cat_cyt + jFFA_upt/3 + jTG_upt_hep_ndnl + jTG_lip_hep_ndnl;

% [ODE] hep_TG_ndnl_ER: hepatic non de novo TG (ER)
dxdt(5) = jTG_ndnl_cyt_to_ER - jTG_ndnl_ER_to_cyt - jVLDL_TG_ndnl_synt;

% [ODE] hep_TG_dnl_cyt: hepatic de novo TG (cytosol)
dxdt(6) = jTG_dnl_synt_cyt - jTG_dnl_cat_cyt + jTG_dnl_ER_to_cyt - jTG_dnl_cyt_to_ER + jTG_upt_hep_dnl + jTG_lip_hep_dnl;

% [ODE] hep_TG_dnl_ER: hepatic de novo TG (ER)
dxdt(7) = jTG_dnl_cyt_to_ER +jTG_dnl_synt_ER - jTG_dnl_ER_to_cyt - jVLDL_TG_dnl_synt;

% [ODE] pl_VLDL_TG_ndnl: plasma VLDL-TG
dxdt(8) = jVLDL_TG_ndnl_synt - jTG_upt_per_ndnl - jTG_lip_per_ndnl - jTG_upt_hep_ndnl - jTG_lip_hep_ndnl;

% [ODE] pl_VLDL_TG_dnl: plasma VLDL_TG
dxdt(9) = jVLDL_TG_dnl_synt - jTG_upt_per_dnl - jTG_lip_per_dnl - jTG_upt_hep_dnl - jTG_lip_hep_dnl;

% [ODE] pl_VLDL_C: plasma VLDL-C
dxdt(10) = jVLDL_CE_synt - jCE_upt_per - jCE_upt_hep;

% [ODE] pl_HDL_C: plasma HDL-C
dxdt(11) = jCE_for_HDL - jCE_upt_HDL;

% [ODE] pl_FFA: plasma free FA
dxdt(12) = jFFA_secr - jFFA_upt;

dxdt = dxdt(:);