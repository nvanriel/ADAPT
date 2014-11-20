function MODEL = minGlucModel()

MODEL.DESCRIPTION = 'Minimal Glucose model by Dalla Man et. al';

MODEL.PREDICTOR = {
    't' [0 240] {'time' 'min' 'time'}
};

MODEL.CONSTANTS = {
    'Gb'   'Gb' {'conc.' 'mg/dl' 'Basal glucose'}
    'Gtot' 40   {'mass'  'g'     'Glucose intake'}
    'V'    1.7  {''      'dl/kg' 'Distribution volume'}
    'BW'   'BW' {'mass'  'kg'    'Avg. body weight'}
};

MODEL.INPUTS = {
    'Insulin' 'Data'     {'InsulinRel'}                                                              'Linear' {'conc.' 'uU/ml'     'Above basal insulin'}
    'Ra'      'Function' {[0 15 30 60 120 180 240], 'ra0', 'ra1', 'ra2', 'ra3', 'ra4', 'ra5', 'ra6'} 'Linear' {''      'mg/kg/min' 'Rate of appearance'}
};

MODEL.PARAMETERS = {
    'p1'  0 .014 []      {'rate' '1/min' 'p1'}  % Fractional glucose effectiveness (GE)
    'p2'  0 .03  []      {'rate' '1/min' 'p2'}  % Rate constant of remove insulin compartment
    'p3'  1 1e-6 [0 inf] {'rate' 'ml/uU' 'p3'}  % Scale factor for amplitude of insulin action
    
    'ra0' 0 0    []      {}                     %
    'ra1' 1 1    [0 inf] {}                     %
    'ra2' 1 1    [0 inf] {}                     %
    'ra3' 1 1    [0 inf] {}                     % Rate of appearence parameters
    'ra4' 1 1    [0 inf] {}                     %
    'ra5' 1 1    [0 inf] {}                     %
    'ra6' 1 1    [0 inf] {}                     %
    
    'asd' 0 'p3' [] {}
};

MODEL.STATES = {
    'Glucose' 'Gb' 'dGdt'      {'conc.' 'mg/dl' 'Glucose'}
    'X'       0    'rX1 + rX2' {''      '-'     'Insulin action'}
};

MODEL.REACTIONS = {
    'rG1a' '-(p1) * Glucose' {}
    'rG1b' '-(X) * Glucose'  {}
    'rG2'  'p1 * Gb'         {}
    'rG3'  'Ra/V'            {}
    
    'rX1'  '-p2 * X'         {}
    'rX2'  'p3 * Insulin'    {}
    
    'dGdt' 'rG1a + rG1b + rG2 + rG3' {}
    
    % ---
    'Ra_mg' 'Ra * BW'        {'' 'mg/min'        'Rate of appearance'}
    'Ra_g'  'Ra_mg / 1000'   {'' 'g/min'         'Rate of appearance'}
    'SI'    'p3/p2'          {'' '1/min/(uU/ml)' 'Fractional insulin sensitivity index'}
};