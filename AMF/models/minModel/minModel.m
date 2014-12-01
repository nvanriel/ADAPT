function MODEL = minModel()

MODEL.DESCRIPTION = 'Combined minimal model by Dalla Man et. al';

MODEL.PREDICTOR = {
    't' [0 240] {'time' 'min' 'time'}
};

MODEL.CONSTANTS = {
    'BW'  'BW' {}
    'Gb'  'G'  {}
    'CPb' 'CP' {}
    'Ib'  'I'  {}
    
    'Gtot' 40  {'mass'  'g'     'Gluc intake'}
    'HEi'  .4  {}
    
    'Vg'   1.7 {''      'dl/kg' 'dV gluc'}
};

MODEL.INPUTS = {
%     'G'    'Data'   {'G'}    'Linear' {}
%     'dGdt' 'Data'   {'dGdt'} 'Linear' {}
    
    'HE' 'Function' {[-45 0 15 30 45 60 90 120 180 240],'heb','he0','he1','he2','he3','he4','he5','he6','he7','he8',} 'Linear' {}
    'Ra' 'Function' {[-45 0 15 30 45 60 90 120 180 240],'rab','ra0','ra1','ra2','ra3','ra4','ra5','ra6','ra7','ra8',} 'Linear' {'' 'mg/kg/min' 'Ra'}
};

MODEL.PARAMETERS = {
    % van Cauter
    'k01' 0 .067  [] {}
    'k12' 0 .051  [] {}
    'k21' 0 .065  [] {}
    'dV'  0 .0422 [] {}
    
    % Campioni
    'PHId'  1 200 [] {'' '10^-9' 'PHId(=kG)'}
    'PHIs'  1 20  [] {'' '10^-9/min' 'PHIs(=beta)'}
    'T'     0 3  [] {}
    
    % Insulin
    'Vi'    0 10  [] {}
    
    % Hepatic extraction
    'heb' 0 .6 [0 1] {}                     %
    'he0' 0 .6 [0 1] {}                     %
    'he1' 1 .6 [0 1] {}                     %
    'he2' 1 .6 [0 1] {}                     %
    'he3' 1 .6 [0 1] {}                     %
    'he4' 1 .6 [0 1] {}                     % HE pars
    'he5' 1 .6 [0 1] {}                     %
    'he6' 1 .6 [0 1] {}                     %
    'he7' 1 .6 [0 1] {}                     %
    'he8' 1 .6 [0 1] {}                     %

	% Glucose
    'p1'  0 .014 [] {'rate' '1/min' 'p1'}  % Fractional glucose effectiveness (GE)
    'p2'  0 .03  [] {'rate' '1/min' 'p2'}  % Rate constant of remove insulin compartment
    'p3'  1 1e-6 [] {'rate' 'ml/uU' 'p3'}  % Scale factor for amplitude of insulin action
    
    'rab' 0 0    [] {}
    'ra0' 0 0    [] {}                     %
    'ra1' 1 1    [] {}                     %
    'ra2' 1 1    [] {}                     %
    'ra3' 1 1    [] {}                     %
    'ra4' 1 1    [] {}                     % Rate of appearence parameters
    'ra5' 1 1    [] {}                     %
    'ra6' 1 1    [] {}                     %
    'ra7' 1 1    [] {}                     %
    'ra8' 1 1    [] {}                     %
};

MODEL.STATES = {
    % C-peptide
    'CP1' 0   '-(k01 + k21) * CP1 + k12 * CP2 + SR' {}
    'CP2' 0   '-k12 * CP2 + k21 * CP1'              {}
    'Y'   0   '-1/T * (Y - PHIs * 10^-9 * pG)'      {}
    
    % Insulin
    'I'   'I' '-(CL/Vi) * I + IDR / Vi'             {}
    
    % Glucose
    'G'   'G' 'dGdt' {'conc.' 'mg/dl' 'Glucose'}
    'X'   0   'dXdt' {''      '-'     'Insulin action'}
    'Gin' 0   'Ra_g' {'mass'  'g'     'App. gluc'}
};

MODEL.REACTIONS = {
    % Glucose
    'Ir' 'if((I-Ib) > 0, I-Ib,0)'            {}

    'dGdt' '-(p1 + X) * G + p1 * Gb + Ra/Vg * 1e9/18.0182' {}
    'dXdt' '-p2 * X + p3/6.94 * Ir'          {}

    'Ra_g'  'Ra * BW / 1000'                 {'' 'g/min'         'Ra'}
    'SI'    'p3/p2'                          {'' '1/min/(uU/ml)' 'Frac. SI idx'}

    % C-peptide
    'V1'    'dV * BW'                             {}

    'pdGdt' 'if((G < Gb) || (dGdt < 0), 0, dGdt)' {}
    'pG'    'if((G < Gb), 0, G-Gb)'               {}

    'SRs' 'Y'                                     {}
    'SRd' 'PHId * 10^-9 * pdGdt'                  {}
    'SRb' 'CPb * k01'                             {}
    
    'SR'  'SRs + SRd'                             {}
    
    'ISR'   '(SR + SRb) * V1'                     {}
    'ISR2'  'ISR / BW'                            {}
    
    'CP'    'CP1 + CPb'                           {'conc.' 'pM' 'CPeptide'}
    
	'PHIb'  'SRb / Gb'                            {}
    
    % Insulin
    'IDR'   'ISR * (1 - HE)'                      {}
    'CL'    'SRb * V1 * (1 - heb) / Ib'           {}
};