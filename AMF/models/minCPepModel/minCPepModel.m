function MODEL = minCPepModel()

MODEL.DESCRIPTION = 'Minimal CPeptide model by Dalla Man et. al';

MODEL.PREDICTOR = {
    't' [0 240] {'time' 'min' 'time'}
};

MODEL.CONSTANTS = {
    'BW' 'BW' {}
    'Gb' 'Glucose' {}
};

MODEL.INPUTS = {
    'G'    'Data' {'Glucose'}     'Linear' {}
    'dGdt' 'Data' {'GlucoseDiff'} 'Linear' {}
};

MODEL.PARAMETERS = {
    'k01'  0 .067  [] {}
    'k12'  0 .051  [] {}
    'k21'  0 .065  [] {}
    'dV'   0 .0422 [] {}
    
    'kG'   1 1     [] {}
    'B'    1 .1    [] {}
    
    'T'    1 5     [] {}
    %'h'    1 6.1599e+09 [] {}
};

MODEL.STATES = {
    'q1' 0 'rq11 + rq12 + ISR'              {}
    'q2' 0 'rq21 + rq22'                    {}
    'yy'  0 '-1/T * (yy - B * 10^-6 * abG)' {}
};

MODEL.REACTIONS = {
    'rq11'  '-(k01 + k21) * q1'                   {}
    'rq12'  'k12 * q2'                            {}
    'rq21'  '-k12 * q2'                           {}
    'rq22'  'k21 * q1'                            {}
    
    'pdGdt' 'if((G < Gb) || (dGdt < 0), 0, dGdt)' {}
    'pG'    'if((G < Gb), Gb, G)'                 {}

    'abG'   'pG - Gb'                             {}
    
    'ISR'   'yy + kG * 10^-6 * pdGdt'             {}
    'c1'    'q1 / (dV * BW)'                      {'conc.' 'nM' 'Above basal CPeptide'}
};