function MODEL = minGlucModel2()

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
    'I' 'Data' {'I'} 'Linear' {'conc.' 'uU/ml' 'Insulin'}
};

MODEL.PARAMETERS = {
    'p1'  0 .014       [] {'rate' '1/min' 'p1'}  % Fractional glucose effectiveness (GE)
    'p2'  0 .03        [] {'rate' '1/min' 'p2'}  % Rate constant of remove insulin compartment
    'p3'  0 1.0539e-05 [] {'rate' 'ml/uU' 'p3'}  % Scale factor for amplitude of insulin action
    
    'Ra'  1 0          [] {}
};

MODEL.STATES = {
    'G'   'G' 'dGdt' {'conc.' 'mg/dl' 'Glucose'}
    'X'   0   'dXdt' {''      '-'     'Insulin action'}
    'Gin' 0   'Ra_g' {'mass'  'g'     'App. gluc'}
};

MODEL.REACTIONS = {
    'Ir' 'if((I-Ib) > 0, I-Ib,0)'            {}
    
    'dGdt' '-(p1 + X) * G + p1 * Gb + Ra/Vg' {}
    'dXdt' '-p2 * X + p3 * Ir'               {}
    
    % ---
    'Ra_g'  'Ra * BW / 1000'                 {'' 'g/min'         'Ra'}
    'SI'    'p3/p2'                          {'' '1/min/(uU/ml)' 'Frac. SI idx'}
};