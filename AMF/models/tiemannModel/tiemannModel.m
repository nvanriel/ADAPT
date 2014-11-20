function MODEL = tiemannModel()

MODEL.PREDICTOR = {
    't' [0 504] {}
};

MODEL.PARAMETERS = {
    'Vm_FC_prod'      1 0 [] {}
    'Vm_FC_met'       1 0 [] {}
    'Vm_CE_for'       1 0 [] {}
    'Vm_CE_def'       1 0 [] {}
    'Vm_CE_ER_for'    1 0 [] {}
    'Vm_CE_ER_def'    1 0 [] {}
    'Vm_TG_prod'      1 0 [] {}
    'Vm_TG_met'       1 0 [] {}
    'Vm_TG_for'       1 0 [] {}
    'Vm_TG_ER_prod'   1 0 [] {}
    'Vm_TG_ER_for'    1 0 [] {}
    'Vm_FFA_upt'      1 0 [] {}
    'Vm_FFA_prod'     1 0 [] {}
    'Vm_VLDL_TG'      1 0 [] {}
    'Vm_VLDL_CE'      1 0 [] {}
    'Vm_TG_CE_upt'    1 0 [] {}
    'Vm_TG_CE_upt_ph' 1 0 [] {}
    'Vm_TG_hyd'       1 0 [] {}
    'Vm_TG_hyd_ph'    1 0 [] {}
    'Vm_HDL_CE_for'   1 0 [] {}
    'Vm_HDL_CE_upt'   1 0 [] {}
    'Vm_ApoB_prod'    1 0 [] {}
    
    % copied
    'Vm_TG_CE_upt_0'    0 'Vm_TG_CE_upt'    [] {}
    'Vm_TG_CE_upt_ph_0' 0 'Vm_TG_CE_upt_ph' [] {}
};

MODEL.CONSTANTS = {
    'mwTG'          859.2           {}     % molecular weight of TG [g  / mol], Teerlink et al.
    'mvTG'          859.2 * 1.102   {}     % molecular volume of TG [ml / mol], Teerlink et al.
    'mwCE'          647.9           {}     % molecular weight of CE [g  / mol], Teerlink et al.
    'mvCE'          647.9 * 1.058   {}     % molecular volume of CE [ml / mol], Teerlink et al.
    'mwFC'          386.7           {}     % molecular weight of FC [g  / mol], Teerlink et al.
    'mvFC'          386.7 * 1.021   {}     % molecular volume of FC [ml / mol], Teerlink et al.
    'mwPL'          786.0           {}     % molecular weight of PL [g  / mol], Teerlink et al.
    'mvPL'          786.0 * 0.984   {}     % molecular volume of PL [ml / mol], Teerlink et al.
    'mwApoB'        546340          {}     % molecular weight of apoB [g  / mol], Hubner et al.
    'navg'          6.02214179      {}     % number of Avogadro [10^23]
    'uH'            1.660538782     {}     % atomic mass of a hydrogen atom [10^-24]
    'plasma_volume' 0.001           {}     % 4.125% of bodyweight [L]
    'rs'            2               {}     % radius of lipoprotein surface [nm], Hubner et al. 2009
    'npi'           pi              {}     % pi
};

MODEL.STATES = {
    'hep_FC'        'dhep_FC_abs'   'J_FC_production - J_FC_metabolism - J_CE_formation + J_CE_deformation - J_CE_ER_formation + J_CE_ER_deformation' {}
    'hep_CE'        'dhep_CE_abs'   'J_CE_formation - J_CE_deformation + J_CE_upt_2 + J_CE_HDL_upt_2'                                                 {}
    'hep_CE_ER'     0               'J_CE_ER_formation - J_CE_ER_deformation - J_VLDL_CE_1'                                                           {}
    'hep_TG'        'dhep_TG_abs'   '- J_TG_metabolism + J_TG_formation - J_TG_ER_formation + (J_FFA_upt_2/3.0) + J_TG_upt_2 + J_TG_hyd_2'            {}
    'hep_TG_ER'     0               '- J_TG_formation + J_TG_ER_formation - J_VLDL_TG_1'                                                              {}
    'hep_TG_DNL'    0               'J_TG_production - J_TG_metabolism_DNL + J_TG_formation_DNL - J_TG_ER_formation_DNL'                              {}
    'hep_TG_ER_DNL' 0               'J_TG_ER_production - J_TG_formation_DNL + J_TG_ER_formation_DNL - J_VLDL_TG_DNL_1'                               {}
    'plasma_TG'     'dplasma_TG'    'J_VLDL_TG_2 + J_VLDL_TG_DNL_2 - J_TG_upt_1 - J_TG_upt_ph - J_TG_hyd_1 - J_TG_hyd_ph'                             {}
    'plasma_C'      'dplasma_C_0'   'J_VLDL_CE_2 - J_CE_upt_1 - J_CE_upt_ph'                                                                          {}
    'plasma_C_HDL'  'dplasma_C_HDL' 'J_CE_HDL_for - J_CE_HDL_upt_1'                                                                                   {}
    'plasma_FFA'    'dFFA'          'J_FFA_prod - J_FFA_upt_1'                                                                                        {}
};

MODEL.REACTIONS = {
    % cholesterol
    'J_FC_production'          'Vm_FC_prod'                                   {}    %production of free cholesterol
    'J_FC_metabolism'          'Vm_FC_met * hep_FC'                           {}    %metabolism of free cholesterol
    'J_CE_formation'           'Vm_CE_for * hep_FC'                           {}    %formation of cholesterol ester from free cholesterol (cytosol)
    'J_CE_deformation'         'Vm_CE_def * hep_CE'                           {}    %deformation of cholesterol ester to free cholesterol (cytosol)
    'J_CE_ER_formation'        'Vm_CE_ER_for * hep_FC'                        {}    %formation of cholesterol ester from free cholesterol (ER)
    'J_CE_ER_deformation'      'Vm_CE_ER_def * hep_CE_ER'                     {}    %deformation of cholesterol ester to free cholesterol (ER)

    % triglyceride
    'J_TG_production'          'Vm_TG_prod'                                   {}    %production of triglyceride (cytosol)
    'J_TG_metabolism'          'Vm_TG_met * hep_TG'                           {}    %metabolism of triglyceride (cytosol)
    'J_TG_metabolism_DNL'      'Vm_TG_met * hep_TG_DNL'                       {}    %metabolism of triglyceride (cytosol)
    'J_TG_formation'           'Vm_TG_for * hep_TG_ER'                        {}    %transport of triglyceride from ER to cytosol
    'J_TG_formation_DNL'       'Vm_TG_for * hep_TG_ER_DNL'                    {}    %transport of triglyceride from ER to cytosol
    'J_TG_ER_production'       'Vm_TG_ER_prod'                                {}    %production of triglyceride (ER)
    'J_TG_ER_formation'        'Vm_TG_ER_for * hep_TG'                        {}    %transport of triglyceride from cytosol to ER
    'J_TG_ER_formation_DNL'    'Vm_TG_ER_for * hep_TG_DNL'                    {}    %transport of triglyceride from cytosol to ER
    'J_FFA_upt_1'              'Vm_FFA_upt * plasma_FFA'                      {}    %uptake of free fatty acids by the liver (cytosol)
    'J_FFA_upt_2'              'Vm_FFA_upt * plasma_FFA * plasma_volume'      {}    %uptake of free fatty acids by the liver (cytosol)
    'J_FFA_prod'               'Vm_FFA_prod'                                  {}    %

    % lipoprotein production
    'J_VLDL_TG_1'              'Vm_VLDL_TG * hep_TG_ER'                       {}    %amount of triglycerides transported to VLDL
    'J_VLDL_TG_DNL_1'          'Vm_VLDL_TG * hep_TG_ER_DNL'                   {}    %amount of triglycerides transported to VLDL
    'J_VLDL_CE_1'              'Vm_VLDL_CE * hep_CE_ER'                       {}    %amount of cholesterol ester transported to VLDL
    'J_VLDL_TG_2'              'Vm_VLDL_TG * hep_TG_ER / plasma_volume'       {}    %amount of triglycerides transported to VLDL
    'J_VLDL_TG_DNL_2'          'Vm_VLDL_TG * hep_TG_ER_DNL / plasma_volume'   {}    %amount of triglycerides transported to VLDL
    'J_VLDL_CE_2'              'Vm_VLDL_CE * hep_CE_ER / plasma_volume'       {}    %amount of cholesterol ester transported to VLDL

    % lipoprotein uptake
    'J_TG_upt_1'               'Vm_TG_CE_upt * plasma_TG'                     {}    %whole particle uptake by liver (TG)
    'J_CE_upt_1'               'Vm_TG_CE_upt * plasma_C'                      {}    %whole particle uptake by liver (CE)
    'J_TG_upt_ph'              'Vm_TG_CE_upt_ph * plasma_TG'                  {}    %whole particle uptake by peripheral tissue (TG)
    'J_CE_upt_ph'              'Vm_TG_CE_upt_ph * plasma_C'                   {}    %whole particle uptake by peripheral tissue (CE)
    'J_CE_HDL_for'             'Vm_HDL_CE_for'                                {}    %CE uptake from peripheral tissues by HDL
    'J_CE_HDL_upt_1'           'Vm_HDL_CE_upt * plasma_C_HDL'                 {}    %CE uptake by liver from HDL
    'J_TG_hyd_1'               'Vm_TG_hyd * plasma_TG'                        {}    %hydrolysis of TG at liver
    'J_TG_hyd_ph'              'Vm_TG_hyd_ph * plasma_TG'                     {}    %hydrolysis of TG at peripheral tissue
    'J_TG_upt_2'               'Vm_TG_CE_upt * plasma_TG * plasma_volume'     {}    %whole particle uptake by liver (TG)
    'J_CE_upt_2'               'Vm_TG_CE_upt * plasma_C * plasma_volume'      {}    %whole particle uptake by liver (CE)
    'J_CE_HDL_upt_2'           'Vm_HDL_CE_upt * plasma_C_HDL * plasma_volume' {}    %CE uptake by liver from HDL
    'J_TG_hyd_2'               'Vm_TG_hyd * plasma_TG * plasma_volume'        {}    %hydrolysis of TG at liver
    
    % helpers
    'J_VLDL_TG'      'Vm_VLDL_TG * (hep_TG_ER + hep_TG_ER_DNL)'                                         {}
    'J_VLDL_CE'      'Vm_VLDL_CE * hep_CE_ER'                                                           {}
    'J_ApoB_prod'    'Vm_ApoB_prod'                                                                     {}
    'ApoB_count'     'J_ApoB_prod * navg * 10^23 * 10^-6'                                                         {}
    'TG_count'       'J_VLDL_TG * navg * 10^23 * 10^-6 / ApoB_count'                                              {}
    'CE_count'       'J_VLDL_CE * navg * 10^23 * 10^-6 / ApoB_count'                                              {}
    'DNL'            '(hep_TG_DNL + hep_TG_ER_DNL) / (hep_TG + hep_TG_ER + hep_TG_DNL + hep_TG_ER_DNL)' {}

    'lipo_vc'        '( (TG_count * mvTG) + (CE_count * mvCE) ) * (pow(10,21) / (navg * 10^23))'                         {}
    'lipo_rc'        'pow((3 * lipo_vc) / (4 * npi), 1/3)'                                               {}
    'VLDL_diameter'  '(lipo_vc + lipo_rc) * 2'                                                          {}
    'VLDL_clearance' '(Vm_TG_CE_upt + Vm_TG_CE_upt_ph) / (Vm_TG_CE_upt_0 + Vm_TG_CE_upt_ph_0)'          {}

    'J_CE_HDL_upt'   'Vm_HDL_CE_upt * plasma_C_HDL'                                                     {}
    
    % observables
    'dhep_TG_abs'      'hep_TG + hep_TG_ER + hep_TG_DNL + hep_TG_ER_DNL' {}
    'dhep_CE_abs'      'hep_CE + hep_CE_ER'                              {}
    'dhep_FC_abs'      'hep_FC'                                          {}
    'dplasma_C'        'plasma_C + plasma_C_HDL'                         {}
    'dplasma_TG'       'plasma_TG'                                       {}
    'dVLDL_TG_C_ratio' 'TG_count / CE_count'                             {}

    'dVLDL_diameter'   'VLDL_diameter'                                   {}
    'dVLDL_production' 'J_VLDL_TG'                                       {}
    'dVLDL_clearance'  'VLDL_clearance'                                  {}

    'dDNL'             'DNL'                                             {}
    'dFFA'             'plasma_FFA'                                      {}
    
    'dplasma_C_HDL'    'plasma_C_HDL'                                    {}
    'dhep_HDL_CE_upt'  'J_CE_HDL_upt * plasma_volume'                    {}
};