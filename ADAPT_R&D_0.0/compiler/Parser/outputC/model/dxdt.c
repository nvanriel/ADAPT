#include "../dxdt.h"



int rhs( realtype t, N_Vector y, N_Vector ydot, void *f_data ) {

	struct mData *data = ( struct mData * ) f_data;

	realtype dxdt , jApoB_prod , jCE_conv_FC_ER , jCE_conv_FC_cyt , jCE_for_HDL , jCE_upt_HDL , jCE_upt_hep , jCE_upt_per , jFC_cat , jFC_conv_CE_ER , jFC_conv_CE_cyt , jFC_synt , jFFA_secr , jFFA_upt , jTG_dnl_ER_to_cyt , jTG_dnl_cat_cyt , jTG_dnl_cyt_to_ER , jTG_dnl_synt_ER , jTG_dnl_synt_cyt , jTG_lip_hep_dnl , jTG_lip_hep_ndnl , jTG_lip_per_dnl , jTG_lip_per_ndnl , jTG_ndnl_ER_to_cyt , jTG_ndnl_cat_cyt , jTG_ndnl_cyt_to_ER , jTG_upt_hep_dnl , jTG_upt_hep_ndnl , jTG_upt_per_dnl , jTG_upt_per_ndnl , jVLDL_CE_synt , jVLDL_TG_dnl_synt , jVLDL_TG_ndnl_synt ;

	realtype *stateVars;
	realtype *ydots;

	stateVars = NV_DATA_S(y);
	ydots = NV_DATA_S(ydot);

	
	jFC_synt =data->u[0];
	jFC_cat =data->u[1]*stateVars[0];
	jFC_conv_CE_cyt =data->u[2]*stateVars[0];
	jFC_conv_CE_ER =data->u[3]*stateVars[0];
	jCE_conv_FC_cyt =data->u[4]*stateVars[1];
	jCE_conv_FC_ER =data->u[5]*stateVars[2];
	jTG_dnl_synt_cyt =data->u[6];
	jTG_ndnl_cat_cyt =data->u[7]*stateVars[3];
	jTG_dnl_cat_cyt =data->u[7]*stateVars[5];
	jTG_ndnl_ER_to_cyt =data->u[8]*stateVars[4];
	jTG_dnl_ER_to_cyt =data->u[8]*stateVars[6];
	jTG_ndnl_cyt_to_ER =data->u[9]*stateVars[3];
	jTG_dnl_cyt_to_ER =data->u[9]*stateVars[5];
	jTG_lip_per_ndnl =data->u[10]*stateVars[7];
	jTG_lip_hep_ndnl =data->u[12]*stateVars[7];
	jTG_upt_per_ndnl =data->u[11]*stateVars[7];
	jTG_lip_per_dnl =data->u[10]*stateVars[8];
	jTG_lip_hep_dnl =data->u[12]*stateVars[8];
	jTG_upt_per_dnl =data->u[11]*stateVars[8];
	jCE_upt_per =data->u[11]*stateVars[9];
	jTG_upt_hep_ndnl =data->u[13]*stateVars[7];
	jTG_upt_hep_dnl =data->u[13]*stateVars[8];
	jCE_upt_hep =data->u[13]*stateVars[9];
	jVLDL_TG_ndnl_synt =data->u[14]*stateVars[4];
	jVLDL_TG_dnl_synt =data->u[14]*stateVars[6];
	jVLDL_CE_synt =data->u[15]*stateVars[2];
	jCE_for_HDL =data->u[16];
	jCE_upt_HDL =data->u[17]*stateVars[10];
	jFFA_upt =data->u[18]*stateVars[11];
	jFFA_secr =data->u[19];
	jApoB_prod =data->u[20];
	jTG_dnl_synt_ER =data->u[21];
	
	
	/* [ODE] hep_FC: hepatic free cholesterol*/
	ydots[0] =jFC_synt +jCE_conv_FC_cyt +jCE_conv_FC_ER -jFC_conv_CE_cyt -jFC_conv_CE_ER -jFC_cat;
	
	/* [ODE] hep_CE_cyt: hepatic CE (cytosol)*/
	ydots[1] =jCE_upt_HDL +jFC_conv_CE_cyt -jCE_conv_FC_cyt +jCE_upt_hep;
	
	/* [ODE] hep_CE_ER: hepatic CE (ER)*/
	ydots[2] =jFC_conv_CE_ER -jCE_conv_FC_ER -jVLDL_CE_synt;
	
	/* [ODE] hep_TG_ndnl_cyt: hepatic non de novo TG (cytosol)*/
	ydots[3] =jTG_ndnl_ER_to_cyt -jTG_ndnl_cyt_to_ER -jTG_ndnl_cat_cyt +jFFA_upt/3 +jTG_upt_hep_ndnl +jTG_lip_hep_ndnl;
	
	/* [ODE] hep_TG_ndnl_ER: hepatic non de novo TG (ER)*/
	ydots[4] =jTG_ndnl_cyt_to_ER -jTG_ndnl_ER_to_cyt -jVLDL_TG_ndnl_synt;
	
	/* [ODE] hep_TG_dnl_cyt: hepatic de novo TG (cytosol)*/
	ydots[5] =jTG_dnl_synt_cyt -jTG_dnl_cat_cyt +jTG_dnl_ER_to_cyt -jTG_dnl_cyt_to_ER +jTG_upt_hep_dnl +jTG_lip_hep_dnl;
	
	/* [ODE] hep_TG_dnl_ER: hepatic de novo TG (ER)*/
	ydots[6] =jTG_dnl_cyt_to_ER +jTG_dnl_synt_ER -jTG_dnl_ER_to_cyt -jVLDL_TG_dnl_synt;
	
	/* [ODE] pl_VLDL_TG_ndnl: plasma VLDL-TG*/
	ydots[7] =jVLDL_TG_ndnl_synt -jTG_upt_per_ndnl -jTG_lip_per_ndnl -jTG_upt_hep_ndnl -jTG_lip_hep_ndnl;
	
	/* [ODE] pl_VLDL_TG_dnl: plasma VLDL_TG*/
	ydots[8] =jVLDL_TG_dnl_synt -jTG_upt_per_dnl -jTG_lip_per_dnl -jTG_upt_hep_dnl -jTG_lip_hep_dnl;
	
	/* [ODE] pl_VLDL_C: plasma VLDL-C*/
	ydots[9] =jVLDL_CE_synt -jCE_upt_per -jCE_upt_hep;
	
	/* [ODE] pl_HDL_C: plasma HDL-C*/
	ydots[10] =jCE_for_HDL -jCE_upt_HDL;
	
	/* [ODE] pl_FFA: plasma free FA*/
	ydots[11] =jFFA_secr -jFFA_upt;
	
	


	#ifdef NON_NEGATIVE
		return 0;
	#else
		return 0;
	#endif

};

