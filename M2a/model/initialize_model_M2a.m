function m = initialize_model_M2a(m,varargin)


%% state variables
data = varargin{1};
m.x0(1)     = data.hep_FC.m(1);
m.x0(2:3)   = data.hep_CE.m(1)/2;
m.x0(4:7)   = data.hep_TG.m(1)/4;
m.x0(8)     = data.pl_VLDL_TG.m(1)*0.8;
m.x0(9)     = data.pl_VLDL_TG.m(1)*0.2;
m.x0(10)     = data.pl_TC.m(1) - data.pl_HDL_C.m(1);
m.x0(11)    = data.pl_HDL_C.m(1);
m.x0(12)    = data.pl_FFA.m(1); 

% get states close to spines wherever possible: 
% state  //  data component  // multiplaction factor
m.x0_spline_adjust{1} = {'hep_FC'       'hep_FC'    '1.0'};
m.x0_spline_adjust{2} = {'hep_CE_cyt'   'hep_CE'    '0.5'};
m.x0_spline_adjust{3} = {'hep_CE_ER'    'hep_CE'    '0.5'};
m.x0_spline_adjust{4} = {'hep_TG_ndnl_cyt'  'hep_TG'    '0.25'};
m.x0_spline_adjust{5} = {'hep_TG_dnl_cyt'   'hep_TG'    '0.25'};
m.x0_spline_adjust{6} = {'hep_TG_dnl_ER'    'hep_TG'    '0.25'};
m.x0_spline_adjust{7} = {'hep_TG_ndnl_ER'   'hep_TG'    '0.25'};
m.x0_spline_adjust{8} = {'pl_VLDL_TG_ndnl'  'pl_VLDL_TG'    '0.8'};
m.x0_spline_adjust{9} = {'pl_VLDL_TG_dnl'   'pl_VLDL_TG'    '0.2'};
m.x0_spline_adjust{10} = {'pl_HDL_C'    'pl_HDL_C'  '1.0'};
m.x0_spline_adjust{11} = {'pl_FFA'  'pl_FFA'    '1.0'};
    

m.eq.x = {'jFC_synt + jCE_conv_FC_cyt + jCE_conv_FC_ER - jFC_conv_CE_cyt - jFC_conv_CE_ER - jFC_cat'
          'jCE_upt_HDL + jFC_conv_CE_cyt - jCE_conv_FC_cyt + jCE_upt_hep'
          'jFC_conv_CE_ER - jCE_conv_FC_ER - jVLDL_CE_synt'
          'jTG_ndnl_ER_to_cyt - jTG_ndnl_cyt_to_ER - jTG_ndnl_cat_cyt + jFFA_upt/3 + jTG_upt_hep_ndnl + jTG_lip_hep_ndnl'
          'jTG_ndnl_cyt_to_ER - jTG_ndnl_ER_to_cyt - jVLDL_TG_ndnl_synt'
          'jTG_dnl_synt_cyt - jTG_dnl_cat_cyt + jTG_dnl_ER_to_cyt - jTG_dnl_cyt_to_ER + jTG_upt_hep_dnl + jTG_lip_hep_dnl'
          'jTG_dnl_cyt_to_ER +jTG_dnl_synt_ER - jTG_dnl_ER_to_cyt - jVLDL_TG_dnl_synt'
          'jVLDL_TG_ndnl_synt - jTG_upt_per_ndnl - jTG_lip_per_ndnl - jTG_upt_hep_ndnl - jTG_lip_hep_ndnl'
          'jVLDL_TG_dnl_synt - jTG_upt_per_dnl - jTG_lip_per_dnl - jTG_upt_hep_dnl - jTG_lip_hep_dnl'
          'jVLDL_CE_synt - jCE_upt_per - jCE_upt_hep'
          'jCE_for_HDL - jCE_upt_HDL'
          'jFFA_secr - jFFA_upt'};
      
m.info.x{1} = {'hep_FC'             'hepatic free cholesterol'          'umol'    'FC_{hep}'};
m.info.x{2} = {'hep_CE_cyt'         'hepatic CE (cytosol)'              'umol'    'CE_{hep, cyt}'};
m.info.x{3} = {'hep_CE_ER'          'hepatic CE (ER)'                   'umol'    'CE_{hep, ER}'};
m.info.x{4} = {'hep_TG_ndnl_cyt'	'hepatic non de novo TG (cytosol)'	'umol'    'TG_{hep, cyt}^{ndnl}'};
m.info.x{5} = {'hep_TG_ndnl_ER'     'hepatic non de novo TG (ER)'       'umol'    'TG_{hep, ER}^{ndnl}'};
m.info.x{6} = {'hep_TG_dnl_cyt'     'hepatic de novo TG (cytosol)'      'umol'    'TG_{hep, cyt}^{dnl}'};
m.info.x{7} = {'hep_TG_dnl_ER'      'hepatic de novo TG (ER)'           'umol'    'TG_{hep, ER}^{dnl}'};
m.info.x{8} = {'pl_VLDL_TG_ndnl'    'plasma VLDL-TG'                    'umol'    'VLDL-TG_{pl}'};
m.info.x{9} = {'pl_VLDL_TG_dnl'     'plasma VLDL_TG'                    'umol'    'VLDL_TG_{pl}'};
m.info.x{10} = {'pl_VLDL_C'         'plasma VLDL-C'                     'umol'    'VLDL-C_{pl}'};
m.info.x{11} = {'pl_HDL_C'          'plasma HDL-C'                      'umol'    'HDL-C_{pl}'};
m.info.x{12} = {'pl_FFA'            'plasma free FA'                    'umol'    'FFA_{pl}'};




%% parameters
m.p_init = ones(22,1);
    
m.info.p{1} = {'k_FC_synt'               'hepatic de novo FC synthesis '                      ''}; % gene
m.info.p{2} = {'k_FC_cat'                'free cholesterol catabolism'                        ''}; % gene 
m.info.p{3} = {'k_FC_conv_CE_cyt'        'hepatic conversion of FC to CE (cytosol)'           ''};
m.info.p{4} = {'k_FC_conv_CE_ER'         'hepatic conversion of FC to CE (ER)'                ''};
m.info.p{5} = {'k_CE_conv_FC_cyt'        'hepatic conversion of CE to FC (cytosol)'           ''};
m.info.p{6} = {'k_CE_conv_FC_ER'         'hepatic conversion of CE to FC (ER)'                ''};

m.info.p{7} = {'k_TG_dnl_synt_cyt'       'hepatic de novo TG synthesis (cytosol)'              ''}; % gene 
m.info.p{8} = {'k_TG_cat_cyt'            'hepatic TG catabolism (cytosol)'                     ''}; % gene
m.info.p{9} = {'k_TG_ER_to_cyt'          'hepatic non de novo TG transport (ER to cytosol)'    ''};
m.info.p{10} = {'k_TG_cyt_to_ER'         'hepatic non de novo TG transport (cytosol to ER)'    ''};

m.info.p{11} = {'k_TG_lip_per'           'peripheral TG uptake (lipolysis)'                     ''};
m.info.p{12} = {'k_upt_per'              'peripheral TG uptake (whole particle uptake)'         ''};
m.info.p{13} = {'k_TG_lip_hep'           'hepatic TG uptake (lipolysis)'                        ''}; % gene
m.info.p{14} = {'k_upt_hep'              'hepatic TG uptake (whole particle uptake)'            ''}; % gene

m.info.p{15} = {'k_VLDL_TG_synt'         'hepatic non de novo VLDL-TG secretion'             ''}; % gene
m.info.p{16} = {'k_VLDL_CE_synt'         'hepatic VLDL-C secretion'                          ''}; % gene 

m.info.p{17} = {'k_CE_for_HDL'           'peripheral C efflux to HDL'                        ''};
m.info.p{18} = {'k_CE_upt_HDL'           'hepatic HDL-C uptake'                              ''};

m.info.p{19} = {'k_FFA_upt'              'hepatic FFA uptake'                                ''}; % gene 
m.info.p{20} = {'k_FFA_secr'             'net FFA secretion to plasma'                       ''};

m.info.p{21} = {'k_ApoB_prod'            'hepatic ApoB secretion'                            ''}; % gene 
m.info.p{22} = {'k_TG_dnl_synt_ER'       'hepatic de novo TG synthesis (cytosol)'            ''}; % gene 


    
%% inputs
m.u = [];


%% constants
m.c.Vplasma = 0.001; %[L]
m.c.mwTG = 859.2;            % molecular weight of TG [g/mol], Teerlink et al.
m.c.mvTG = m.c.mwTG * 1.102; % molecular volume of TG [mL/mol], Teerlink et al.
m.c.mwCE = 647.9;            % molecular weight of CE [g/mol], Teerlink et al.
m.c.mvCE = m.c.mwCE * 1.058; % molecular volume of CE [mL/mol], Teerlink et al.
m.c.Navg = 6.02214179e23;    % number of Avogadro
m.c.rs   = 2;                % radius of lipoprotein surface [nm], Hubner et al. 2009


%% fluxes
m.eq.j = {'k_FC_synt'                                                       % 1) hepatic cholesterol synthesis
          'k_FC_cat * hep_FC'                                               % 2) free cholesterol catabolism
          'k_FC_conv_CE_cyt * hep_FC'                                       % 3)
          'k_FC_conv_CE_ER * hep_FC'                                        % 4)
          'k_CE_conv_FC_cyt * hep_CE_cyt'                                   % 5)
          'k_CE_conv_FC_ER * hep_CE_ER'                                     % 6)
          'k_TG_dnl_synt_cyt'                                               % 7)
          'k_TG_cat_cyt * hep_TG_ndnl_cyt'                                  % 8)
          'k_TG_cat_cyt * hep_TG_dnl_cyt'                                   % 9)
          'k_TG_ER_to_cyt * hep_TG_ndnl_ER'                                 % 10)
          'k_TG_ER_to_cyt * hep_TG_dnl_ER'                                  % 11)
          'k_TG_cyt_to_ER * hep_TG_ndnl_cyt'                                % 12)
          'k_TG_cyt_to_ER * hep_TG_dnl_cyt'                                 % 13)       
          
          'k_TG_lip_per * pl_VLDL_TG_ndnl'                                  % 14)
          'k_TG_lip_hep * pl_VLDL_TG_ndnl'                                  % 15)
          'k_upt_per * pl_VLDL_TG_ndnl'                                     % 16)
          'k_TG_lip_per * pl_VLDL_TG_dnl'                                   % 17)
          'k_TG_lip_hep * pl_VLDL_TG_dnl'                                   % 18)
          'k_upt_per * pl_VLDL_TG_dnl'                                      % 19)
                   
          'k_upt_per * pl_VLDL_C'                                           % 20)
          'k_upt_hep * pl_VLDL_TG_ndnl'                                     % 21)
          'k_upt_hep * pl_VLDL_TG_dnl'                                      % 22
          'k_upt_hep * pl_VLDL_C'                                           % 23)   
          'k_VLDL_TG_synt * hep_TG_ndnl_ER'                                 % 24)
          'k_VLDL_TG_synt * hep_TG_dnl_ER'                                  % 25)
          'k_VLDL_CE_synt * hep_CE_ER'                                      % 26)
          'k_CE_for_HDL'                                                    % 27)
          'k_CE_upt_HDL * pl_HDL_C'                                         % 28)
          'k_FFA_upt * pl_FFA'                                              % 29)
          'k_FFA_secr'                                                      % 30)
          'k_ApoB_prod'                                                     % 31)
          'k_TG_dnl_synt_ER'                                                % 32)
          'jApoB_prod * m.c.Navg * 1e-6'                                    % 33)
          '((jVLDL_TG_ndnl_synt+jVLDL_TG_dnl_synt)*m.c.Navg*1e-6)/ApoB_count'
          '((jVLDL_CE_synt)*m.c.Navg*1e-6)/ApoB_count'
          '((TG_count*m.c.mvTG)+(CE_count*m.c.mvCE))*(1e21/m.c.Navg)'
          'power((3*core_volume)/(4*pi),1/3)'
          };
      
m.info.j{1} = {'jFC_synt'               'hepatic de novo FC synthesis '                      ''};
m.info.j{2} = {'jFC_cat'                'free cholesterol catabolism'                        ''};
m.info.j{3} = {'jFC_conv_CE_cyt'        'hepatic conversion of FC to CE (cytosol)'           ''};
m.info.j{4} = {'jFC_conv_CE_ER'         'hepatic conversion of FC to CE (ER)'                ''};
m.info.j{5} = {'jCE_conv_FC_cyt'        'hepatic conversion of CE to FC (cytosol)'           ''};
m.info.j{6} = {'jCE_conv_FC_ER'         'hepatic conversion of CE to FC (ER)'                ''};

m.info.j{7} = {'jTG_dnl_synt_cyt'       'hepatic de novo TG synthesis (cytosol)'              ''};
m.info.j{8} = {'jTG_ndnl_cat_cyt'       'hepatic non de novo TG catabolism (cytosol)'         ''};
m.info.j{9} = {'jTG_dnl_cat_cyt'        'hepatic de novo TG catabolism (cytosol)'             ''};
m.info.j{10} = {'jTG_ndnl_ER_to_cyt'    'hepatic non de novo TG transport (ER to cytosol)'    ''};
m.info.j{11} = {'jTG_dnl_ER_to_cyt'     'hepatic de novo TG transport (ER to cytosol)'        ''};
m.info.j{12} = {'jTG_ndnl_cyt_to_ER'    'hepatic non de novo TG transport (cytosol to ER)'    ''};
m.info.j{13} = {'jTG_dnl_cyt_to_ER'     'hepatic de novo TG transport (cytosol to ER)'        ''};

m.info.j{14} = {'jTG_lip_per_ndnl'      'peripheral TG uptake (lipolysis)'                  ''};
m.info.j{15} = {'jTG_lip_hep_ndnl'      'hepatic TG uptake (lipolysis)'                     ''};
m.info.j{16} = {'jTG_upt_per_ndnl'      'peripheral TG uptake (whole particle uptake)'      ''};
m.info.j{17} = {'jTG_lip_per_dnl'       'peripheral TG uptake (lipolysis)'                  ''};
m.info.j{18} = {'jTG_lip_hep_dnl'       'hepatic TG uptake (lipolysis)'                     ''};
m.info.j{19} = {'jTG_upt_per_dnl'       'peripheral TG uptake (whole particle uptake)'      ''};

m.info.j{20} = {'jCE_upt_per'           'peripheral CE uptake (whole particle uptake)'      ''};
m.info.j{21} = {'jTG_upt_hep_ndnl'      'hepatic TG uptake (whole particle uptake)'         ''};
m.info.j{22} = {'jTG_upt_hep_dnl'       'hepatic TG uptake (whole particle uptake)'         ''};
m.info.j{23} = {'jCE_upt_hep'           'hepatic CE uptake (whole particle uptake)'         ''};


m.info.j{24} = {'jVLDL_TG_ndnl_synt'	'hepatic non de novo VLDL-TG secretion'             ''};
m.info.j{25} = {'jVLDL_TG_dnl_synt'     'hepatic de novo VLDL-TG secretion'                 ''};
m.info.j{26} = {'jVLDL_CE_synt'         'hepatic VLDL-C secretion'                          ''};

m.info.j{27} = {'jCE_for_HDL'           'peripheral C efflux to HDL'                        ''};
m.info.j{28} = {'jCE_upt_HDL'           'hepatic HDL-C uptake'                              ''};

m.info.j{29} = {'jFFA_upt'              'hepatic FFA uptake'                                ''};
m.info.j{30} = {'jFFA_secr'             'net FFA secretion to plasma'                       ''};

m.info.j{31} = {'jApoB_prod'            'hepatic ApoB secretion'                            ''};
m.info.j{32} = {'jTG_dnl_synt_ER'       'hepatic TG synthesis (ER)'                         ''};

% helper functions:
m.info.j{33} = {'ApoB_count'    'number of ApoB molecules [helper function]'    '-'};
m.info.j{34} = {'TG_count'      'number of TG molecules [helper function]'      '-'};
m.info.j{35} = {'CE_count'      'number of CE molecules [helper function]'      '-'};
m.info.j{36} = {'core_volume'   'core volume of lipoprotein [helper function]'  'nm3'};
m.info.j{37} = {'core_radius'   'core radius of lipoprotein [helper function]'  'nm'};
m.info.j_helper = 33:37; %indices of helper functions



%% observable pairs [model-component data-component]
m.eq.y = {{'hep_TG_ndnl_cyt + hep_TG_ndnl_ER + hep_TG_dnl_cyt + hep_TG_dnl_ER' 'hep_TG'}
          {'hep_CE_cyt + hep_CE_ER' 'hep_CE'}
          {'hep_FC' 'hep_FC'}
          {'pl_VLDL_C + pl_HDL_C' 'pl_TC'}
          {'pl_HDL_C' 'pl_HDL_C'}                                           
          {'pl_VLDL_TG_dnl + pl_VLDL_TG_ndnl' 'pl_VLDL_TG'}
          {'pl_FFA' 'pl_FFA'}                                            
          {'TG_count/CE_count' 'VLDL_TG_C_ratio'}
          {'2*(core_radius + m.c.rs)' 'VLDL_diameter'}                    
          {'jVLDL_TG_ndnl_synt + jVLDL_TG_dnl_synt' 'VLDL_TG_production'}   
%           {'k_upt_hep' 'VLDL_clearance'}               
          {'(hep_TG_dnl_cyt + hep_TG_dnl_ER) / (hep_TG_ndnl_cyt + hep_TG_ndnl_ER + hep_TG_dnl_cyt + hep_TG_dnl_ER)' 'hep_DNL'} 
          {'jTG_ndnl_cat_cyt + jTG_dnl_cat_cyt', 'jTG_Oxi'}
          {'(k_upt_hep + k_TG_lip_hep)/(k_upt_hep + k_TG_lip_hep + k_upt_per + k_TG_lip_per)', 'hepTGuptake_Olivecrona' }
%           {'jCE_upt_HDL * m.c.Vplasma' 'CE_upt_HDL'}
          }; 

% in cost fuction:
m.info.y{1} = {'hep_TG'                 'hepatic TG'                    '\mumol'};
m.info.y{2} = {'hep_CE'                 'hepatic CE'                    '\mumol'};
m.info.y{3} = {'hep_FC'                 'hepatic FC'                    '\mumol'};
m.info.y{4} = {'pl_TC'                  'plasma total C'                '\mumol'};
m.info.y{5} = {'pl_HDL_C'               'plasma HDL-C'                  '\mumol'};
m.info.y{6} = {'pl_VLDL_TG'             'plasma TG'                     '\mumol'};
m.info.y{7} = {'pl_FFA'                 'plasma FFA'                    '\mumol'};
m.info.y{8} = {'VLDL_TG_C_ratio'        'VLDL TG:C ratio'               '-'};
m.info.y{9} = {'VLDL_diameter'          'VLDL diameter'                 '-'};
m.info.y{10} = {'VLDL_TG_production'    'VLDL production'              '\mumol/h'};
% m.info.y{11} = {'VLDL_clearance'        'VLDL catabolic rate'           '1/h'};
m.info.y{11} = {'hep_DNL'               'de novo lipogenesis'           '-'};
m.info.y{12} = {'jTG_Oxi'               'hepatic fatty acid oxidation'  '\mumol/h'};
m.info.y{13} = {'hepTGuptake'           'hepatic TG uptake'             '1/h'};


%% genes

% m.par_ass_genes = [];
% m.not_associated = 1:15;

% gene info numbers are due to historical reasons,
% any numbers go as long as the numbers in the array of m.par_aass_genes
% correspond to those in m.info.genes
m.par_ass_genes.k_upt_hep = [37 38 40];
m.info.genes{37} = 'ldlr';
m.info.genes{38} = 'vldlr';
m.info.genes{40} = 'lrp1';

m.par_ass_genes.k_TG_lip_hep = 29;
m.info.genes{29} = 'lpl';

m.par_ass_genes.k_FC_synt = [31 28 33]; 
m.info.genes{31} = 'sqs';
m.info.genes{28} = 'hmgcoared';
m.info.genes{33} = 'srebp2';

m.par_ass_genes.k_FC_cat = [35 24 26];
m.info.genes{35} = 'abcg1';
m.info.genes{24} = 'abcg5';
m.info.genes{26} = 'cyp7a1';

m.par_ass_genes.k_TG_dnl_synt_cyt = [19 27 20 32 6];
m.par_ass_genes.k_TG_dnl_synt_ER = [19 27 20 32 6];
m.info.genes{19} = 'gpat';
m.info.genes{27} = 'fas';
m.info.genes{20} = 'me1';
m.info.genes{32} = 'srebp1c';
m.info.genes{6}  = 'scd1';

m.par_ass_genes.k_TG_cat_cyt =[1 4 23 2];
m.info.genes{1} = 'lcad';
m.info.genes{4} = 'aox';
m.info.genes{23}= 'hmgcoas';
m.info.genes{2} = 'ucp2';

m.par_ass_genes.k_VLDL_TG_synt = 42;
m.par_ass_genes.k_VLDL_CE_synt = 42;
m.par_ass_genes.k_ApoB_prod = 45;
m.info.genes{42} = 'mtp';
m.info.genes{45} = 'apob';

m.par_ass_genes.k_FFA_upt = [34 5];
m.info.genes{34} = 'cd36';
m.info.genes{5}  = 'ap2';

% id's of parameters not associated with gene expression
m.not_associated =  [ 3 4 5 6 9 10 11 12 17 18 20];

%% extra conditions
m.conditional = '';
% m.conditional = 'if (j_sim(15,end) + j_sim(18,end)) / (j_sim(14,end) + j_sim(16,end) + j_sim(15,end) + j_sim(18,end)) > 0.1 \n\t error = error*5; \n end \n';

%% model constants and variables
m.info.t_unit = 'h';
m.info.t_max = 504;
m.info.observfile = @observables_M2a;