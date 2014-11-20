function DATASET = tiemannData()

DATASET.DESCRIPTION = 'Tiemann model data (Oosterveer & Xie)';

DATASET.FILE = 'tiemannData';
DATASET.TYPE = 'Collection';

DATASET.GROUPS = {
    'oosterveer'
};

DATASET.FIELDS = {
    'dhep_TG_abs'        1 't1' 'hep_TG_abs'      'hep_TG_abs_std'      1 []
    'dhep_CE_abs'        1 't1' 'hep_CE_abs'      'hep_CE_abs_std'      1 []
    'dhep_FC_abs'        1 't1' 'hep_FC_abs'      'hep_FC_abs_std'      1 []
    'dplasma_C'          1 't1' 'plasma_TC_FPLC'  'plasma_TC_FPLC_std'  1 []
    'dplasma_TG'         1 't1' 'plasma_TG_FPLC'  'plasma_TG_FPLC_std'  1 []
    'dVLDL_TG_C_ratio'   1 't2' 'VLDL_TG_C_ratio' 'VLDL_TG_C_ratio_std' 1 []
    'dVLDL_diameter'     1 't2' 'VLDL_diameter'   'VLDL_diameter_std'   1 []
    'dVLDL_production'   1 't2' 'VLDL_production' 'VLDL_production_std' 1 []
    'dVLDL_clearance'    1 't2' 'VLDL_clearance'  'VLDL_clearance_std'  1 []
    'dDNL'               1 't1' 'hep_DNL'         'hep_DNL_std'         1 []
    'dFFA'               1 't1' 'plasma_FFA'      'plasma_FFA_std'      1 []
    
    'dhep_HDL_CE_upt'    1 't3' 'hep_HDL_CE_upt'    'hep_HDL_CE_upt_std'        1 []
    'dplasma_C_HDL_FPLC' 0 't1' 'plasma_C_HDL_FPLC_2' 'plasma_C_HDL_FPLC_2_std' 1 []
};

DATASET.FUNCTIONS = {
    %name           %obs %func %valArgs                            %stdArg
    'dplasma_C_HDL' 1    @prod {'dplasma_C', 'dplasma_C_HDL_FPLC'} 'dplasma_C_HDL_FPLC'
    'dplasma_C_0'   0    @diff {'dplasma_C', 'dplasma_C_HDL'}      'dplasma_C'
};