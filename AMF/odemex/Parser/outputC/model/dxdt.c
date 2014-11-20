#include "../dxdt.h"



int rhs( realtype t, N_Vector y, N_Vector ydot, void *f_data ) {

	struct mData *data = ( struct mData * ) f_data;

	realtype ApoB_count , CE_count , DNL , J_ApoB_prod , J_CE_ER_deformation , J_CE_ER_formation , J_CE_HDL_for , J_CE_HDL_upt , J_CE_HDL_upt_1 , J_CE_HDL_upt_2 , J_CE_deformation , J_CE_formation , J_CE_upt_1 , J_CE_upt_2 , J_CE_upt_ph , J_FC_metabolism , J_FC_production , J_FFA_prod , J_FFA_upt_1 , J_FFA_upt_2 , J_TG_ER_formation , J_TG_ER_formation_DNL , J_TG_ER_production , J_TG_formation , J_TG_formation_DNL , J_TG_hyd_1 , J_TG_hyd_2 , J_TG_hyd_ph , J_TG_metabolism , J_TG_metabolism_DNL , J_TG_production , J_TG_upt_1 , J_TG_upt_2 , J_TG_upt_ph , J_VLDL_CE , J_VLDL_CE_1 , J_VLDL_CE_2 , J_VLDL_TG , J_VLDL_TG_1 , J_VLDL_TG_2 , J_VLDL_TG_DNL_1 , J_VLDL_TG_DNL_2 , TG_count , VLDL_clearance , VLDL_diameter , Vm_ApoB_prod , Vm_CE_ER_def , Vm_CE_ER_for , Vm_CE_def , Vm_CE_for , Vm_FC_met , Vm_FC_prod , Vm_FFA_prod , Vm_FFA_upt , Vm_HDL_CE_for , Vm_HDL_CE_upt , Vm_TG_CE_upt , Vm_TG_CE_upt_0 , Vm_TG_CE_upt_ph , Vm_TG_CE_upt_ph_0 , Vm_TG_ER_for , Vm_TG_ER_prod , Vm_TG_for , Vm_TG_hyd , Vm_TG_hyd_ph , Vm_TG_met , Vm_TG_prod , Vm_VLDL_CE , Vm_VLDL_TG , dDNL , dFFA , dVLDL_TG_C_ratio , dVLDL_clearance , dVLDL_diameter , dVLDL_production , dhep_CE_abs , dhep_FC_abs , dhep_HDL_CE_upt , dhep_TG_abs , dplasma_C , dplasma_C_HDL , dplasma_TG , dxdt , hep_CE , hep_CE_ER , hep_FC , hep_TG , hep_TG_DNL , hep_TG_ER , hep_TG_ER_DNL , lipo_rc , lipo_vc , mvCE , mvFC , mvPL , mvTG , mwApoB , mwCE , mwFC , mwPL , mwTG , navg , npi , plasma_C , plasma_C_HDL , plasma_FFA , plasma_TG , plasma_volume , rs , uH ;

	realtype *stateVars;
	realtype *ydots;

	stateVars = NV_DATA_S(y);
	ydots = NV_DATA_S(ydot);

	
	
	mwTG =859.2;
	mvTG =946.8384;
	mwCE =647.9;
	mvCE =685.4782;
	mwFC =386.7;
	mvFC =394.8207;
	mwPL =786;
	mvPL =773.424;
	mwApoB =546340;
	navg =6.0221;
	uH =1.6605;
	plasma_volume =0.001;
	rs =2;
	npi =3.1416;
	
	hep_FC =stateVars[0];
	hep_CE =stateVars[1];
	hep_CE_ER =stateVars[2];
	hep_TG =stateVars[3];
	hep_TG_ER =stateVars[4];
	hep_TG_DNL =stateVars[5];
	hep_TG_ER_DNL =stateVars[6];
	plasma_TG =stateVars[7];
	plasma_C =stateVars[8];
	plasma_C_HDL =stateVars[9];
	plasma_FFA =stateVars[10];
	
	Vm_FC_prod =data->p[0];
	Vm_FC_met =data->p[1];
	Vm_CE_for =data->p[2];
	Vm_CE_def =data->p[3];
	Vm_CE_ER_for =data->p[4];
	Vm_CE_ER_def =data->p[5];
	Vm_TG_prod =data->p[6];
	Vm_TG_met =data->p[7];
	Vm_TG_for =data->p[8];
	Vm_TG_ER_prod =data->p[9];
	Vm_TG_ER_for =data->p[10];
	Vm_FFA_upt =data->p[11];
	Vm_FFA_prod =data->p[12];
	Vm_VLDL_TG =data->p[13];
	Vm_VLDL_CE =data->p[14];
	Vm_TG_CE_upt =data->p[15];
	Vm_TG_CE_upt_ph =data->p[16];
	Vm_TG_hyd =data->p[17];
	Vm_TG_hyd_ph =data->p[18];
	Vm_HDL_CE_for =data->p[19];
	Vm_HDL_CE_upt =data->p[20];
	Vm_ApoB_prod =data->p[21];
	Vm_TG_CE_upt_0 =data->p[22];
	Vm_TG_CE_upt_ph_0 =data->p[23];
	
	J_FC_production =Vm_FC_prod;
	J_FC_metabolism =Vm_FC_met *hep_FC;
	J_CE_formation =Vm_CE_for *hep_FC;
	J_CE_deformation =Vm_CE_def *hep_CE;
	J_CE_ER_formation =Vm_CE_ER_for *hep_FC;
	J_CE_ER_deformation =Vm_CE_ER_def *hep_CE_ER;
	J_TG_production =Vm_TG_prod;
	J_TG_metabolism =Vm_TG_met *hep_TG;
	J_TG_metabolism_DNL =Vm_TG_met *hep_TG_DNL;
	J_TG_formation =Vm_TG_for *hep_TG_ER;
	J_TG_formation_DNL =Vm_TG_for *hep_TG_ER_DNL;
	J_TG_ER_production =Vm_TG_ER_prod;
	J_TG_ER_formation =Vm_TG_ER_for *hep_TG;
	J_TG_ER_formation_DNL =Vm_TG_ER_for *hep_TG_DNL;
	J_FFA_upt_1 =Vm_FFA_upt *plasma_FFA;
	J_FFA_upt_2 =Vm_FFA_upt *plasma_FFA *plasma_volume;
	J_FFA_prod =Vm_FFA_prod;
	J_VLDL_TG_1 =Vm_VLDL_TG *hep_TG_ER;
	J_VLDL_TG_DNL_1 =Vm_VLDL_TG *hep_TG_ER_DNL;
	J_VLDL_CE_1 =Vm_VLDL_CE *hep_CE_ER;
	J_VLDL_TG_2 =Vm_VLDL_TG *hep_TG_ER /plasma_volume;
	J_VLDL_TG_DNL_2 =Vm_VLDL_TG *hep_TG_ER_DNL /plasma_volume;
	J_VLDL_CE_2 =Vm_VLDL_CE *hep_CE_ER /plasma_volume;
	J_TG_upt_1 =Vm_TG_CE_upt *plasma_TG;
	J_CE_upt_1 =Vm_TG_CE_upt *plasma_C;
	J_TG_upt_ph =Vm_TG_CE_upt_ph *plasma_TG;
	J_CE_upt_ph =Vm_TG_CE_upt_ph *plasma_C;
	J_CE_HDL_for =Vm_HDL_CE_for;
	J_CE_HDL_upt_1 =Vm_HDL_CE_upt *plasma_C_HDL;
	J_TG_hyd_1 =Vm_TG_hyd *plasma_TG;
	J_TG_hyd_ph =Vm_TG_hyd_ph *plasma_TG;
	J_TG_upt_2 =Vm_TG_CE_upt *plasma_TG *plasma_volume;
	J_CE_upt_2 =Vm_TG_CE_upt *plasma_C *plasma_volume;
	J_CE_HDL_upt_2 =Vm_HDL_CE_upt *plasma_C_HDL *plasma_volume;
	J_TG_hyd_2 =Vm_TG_hyd *plasma_TG *plasma_volume;
	J_VLDL_TG =Vm_VLDL_TG * (hep_TG_ER +hep_TG_ER_DNL);
	J_VLDL_CE =Vm_VLDL_CE *hep_CE_ER;
	J_ApoB_prod =Vm_ApoB_prod;
	ApoB_count =J_ApoB_prod *navg *pow(10,23) *pow(10,-6);
	TG_count =J_VLDL_TG *navg *pow(10,23) *pow(10,-6) /ApoB_count;
	CE_count =J_VLDL_CE *navg *pow(10,23) *pow(10,-6) /ApoB_count;
	DNL = (hep_TG_DNL +hep_TG_ER_DNL) / (hep_TG +hep_TG_ER +hep_TG_DNL +hep_TG_ER_DNL);
	lipo_vc = ( (TG_count *mvTG) + (CE_count *mvCE) ) * (pow(10,21) / (navg *pow(10,23)));
	lipo_rc =pow((3 *lipo_vc) / (4 *npi),1/3);
	VLDL_diameter = (lipo_vc +lipo_rc) *2;
	VLDL_clearance = (Vm_TG_CE_upt +Vm_TG_CE_upt_ph) / (Vm_TG_CE_upt_0 +Vm_TG_CE_upt_ph_0);
	J_CE_HDL_upt =Vm_HDL_CE_upt *plasma_C_HDL;
	dhep_TG_abs =hep_TG +hep_TG_ER +hep_TG_DNL +hep_TG_ER_DNL;
	dhep_CE_abs =hep_CE +hep_CE_ER;
	dhep_FC_abs =hep_FC;
	dplasma_C =plasma_C +plasma_C_HDL;
	dplasma_TG =plasma_TG;
	dVLDL_TG_C_ratio =TG_count /CE_count;
	dVLDL_diameter =VLDL_diameter;
	dVLDL_production =J_VLDL_TG;
	dVLDL_clearance =VLDL_clearance;
	dDNL =DNL;
	dFFA =plasma_FFA;
	dplasma_C_HDL =plasma_C_HDL;
	dhep_HDL_CE_upt =J_CE_HDL_upt *plasma_volume;
	
	ydots[0] =J_FC_production -J_FC_metabolism -J_CE_formation +J_CE_deformation -J_CE_ER_formation +J_CE_ER_deformation;
	ydots[1] =J_CE_formation -J_CE_deformation +J_CE_upt_2 +J_CE_HDL_upt_2;
	ydots[2] =J_CE_ER_formation -J_CE_ER_deformation -J_VLDL_CE_1;
	ydots[3] = -J_TG_metabolism +J_TG_formation -J_TG_ER_formation + (J_FFA_upt_2/3.0) +J_TG_upt_2 +J_TG_hyd_2;
	ydots[4] = -J_TG_formation +J_TG_ER_formation -J_VLDL_TG_1;
	ydots[5] =J_TG_production -J_TG_metabolism_DNL +J_TG_formation_DNL -J_TG_ER_formation_DNL;
	ydots[6] =J_TG_ER_production -J_TG_formation_DNL +J_TG_ER_formation_DNL -J_VLDL_TG_DNL_1;
	ydots[7] =J_VLDL_TG_2 +J_VLDL_TG_DNL_2 -J_TG_upt_1 -J_TG_upt_ph -J_TG_hyd_1 -J_TG_hyd_ph;
	ydots[8] =J_VLDL_CE_2 -J_CE_upt_1 -J_CE_upt_ph;
	ydots[9] =J_CE_HDL_for -J_CE_HDL_upt_1;
	ydots[10] =J_FFA_prod -J_FFA_upt_1;
	
	


	#ifdef NON_NEGATIVE
		return 0;
	#else
		return 0;
	#endif

};

