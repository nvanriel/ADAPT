function DATASET = minCPepData()

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
    'Glucose'     0 't' 'glucose_mean'    'glucose_std'    1e9 []
    'GlucoseDiff' 0 't' 'glucose_diff'    'glucose_std'    1e9 []
    'c1'          1 't' 'cpeptide_rel'    'cpeptide_std'   1e3 []
    'BW'          0 []  'm_mean'          'm_std'          1   []
};