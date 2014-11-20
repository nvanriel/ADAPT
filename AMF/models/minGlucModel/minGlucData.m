function DATASET = minGlucData()

import AMF.functions.*

DATASET.DESCRIPTION = 'Bariatric surgery data';

DATASET.FILE = 'bariatricData';
DATASET.TYPE = 'Collection';

DATASET.GROUPS = {
    't2d_pre'
    't2d_1wk'
    't2d_3mo'
    't2d_1y'
    'ngt_pre'
    'ngt_1wk'
    'ngt_3mo'
    'ngt_1y'
};

DATASET.FIELDS = {
    'Glucose'    1 't' 'glucose_mean'    'glucose_std'    18.0182   []
    'Gb'         0 []  'glucose_ss_mean' 'glucose_ss_std' 18.0182   []
    'Ib'         0 []  'insulin_ss_mean' 'glucose_ss_std' 1000/6.94 []
    'Insulin'    0 't' 'insulin_mean'    'insulin_std'    1000/6.94 []
    'InsulinRel' 0 't' 'insulin_rel'     'insulin_std'    1000/6.94 []
    'BW'         0 []  'm_mean'          'm_std'          1         []
};