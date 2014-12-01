function MODEL = minGlucModel()

MODEL.DESCRIPTION = 'Minimal Glucose model by Dalla Man et. al';

MODEL.PREDICTOR = {
    't' [0 240] {'time' 'min' 'time'}
};

MODEL.CONSTANTS = {
    'Gtot' 40   {'mass'  'g'     'Gluc intake'}
    'Vg'    1.7 {''      'dl/kg' 'dV gluc'}
    'BW'   'BW' {'mass'  'kg'    'Avg. BW'}
    'Gb'   'G'  {}
    'Ib'   'I'  {}
};

MODEL.INPUTS = {
    'I'  'Data'     {'I'}                                                              'Linear' {'conc.' 'uU/ml'     'Insulin'}
    'Ra' 'Function' {[-45 0 15 30 45 60 90 120 180 240], 'rab', 'ra0', 'ra1', 'ra2', 'ra3', 'ra4', 'ra5', 'ra6', 'ra7', 'ra8',} 'Linear' {''      'mg/kg/min' 'Rate of appearance'}
};

MODEL.PARAMETERS = {
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
    'G'   'G' 'dGdt' {'conc.' 'mg/dl' 'Glucose'}
    'X'   0   'dXdt' {''      '-'     'Insulin action'}
    'Gin' 0   'Ra_g' {'mass'  'g'     'App. gluc'}
};

MODEL.REACTIONS = {
    'Ir' 'if((I-Ib) > 0, I-Ib,0)'            {}

    'dGdt' '-(p1 + X) * G + p1 * Gb + Ra/Vg * 1e9/18.0182' {}
    'dXdt' '-p2 * X + p3/6.94 * Ir'          {}
    
    % ---
    'Ra_g'  'Ra * BW / 1000'                 {'' 'g/min'         'Ra'}
    'SI'    'p3/p2'                          {'' '1/min/(uU/ml)' 'Frac. SI idx'}
};