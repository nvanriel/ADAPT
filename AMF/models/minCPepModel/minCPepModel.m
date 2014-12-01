function MODEL = minCPepModel()

MODEL.DESCRIPTION = 'Minimal CPeptide model by Dalla Man et. al';

MODEL.PREDICTOR = {
    't' [0 240] {'time' 'min' 'time'}
};

MODEL.CONSTANTS = {
    'BW'  'BW' {}
    'Gb'  'G'  {}
    'CPb' 'CP' {}
    'Ib'  'I'  {}
};

MODEL.INPUTS = {
    'G'    'Data'   {'G'}    'Linear' {}
    'dGdt' 'Data'   {'dGdt'} 'Linear' {}
    
    'HE' 'Function' {[-45 0 15 30 45 60 90 120 180 240],'heb','he0','he1','he2','he3','he4','he5','he6','he7','he8',} 'Linear' {}
};

MODEL.PARAMETERS = {
    % van Cauter
    'k01' 0 .067  [] {}
    'k12' 0 .051  [] {}
    'k21' 0 .065  [] {}
    'dV'  0 .0422 [] {}
    
    % Campioni
    'PHId'  1 200 [] {'' '-' 'kG'}
    'PHIs'  1 20  [] {'' '1/min' 'beta'}
    'T'     0 1   [] {}
    
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

%     'HE'    0 .6 [0 1] {}
};

MODEL.STATES = {
    'CP1' 0   '-(k01 + k21) * CP1 + k12 * CP2 + SR' {}
    'CP2' 0   '-k12 * CP2 + k21 * CP1'              {}
    'Y'   0   '-1/T * (Y - PHIs * 10^-9 * pG)'      {}
    'I'   'I' '-(CL/Vi) * I + IDR / Vi'             {}
};

MODEL.REACTIONS = {
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