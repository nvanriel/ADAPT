%
% time [min]
%

% data.t = [0 15 30 45 60 90 120 180 240];

data.t2d_pre.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];
data.t2d_1wk.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];
data.t2d_3mo.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];
data.t2d_1y.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];
data.ngt_pre.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];
data.ngt_1wk.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];
data.ngt_3mo.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];
data.ngt_1y.t = [-45 -30 -15 0 15 30 45 60 90 120 180 240];

%
% body weight
%

data.t2d_pre.m_mean = 128.8;
data.t2d_pre.m_std = 13.9;
data.t2d_1wk.m_mean = 127;
data.t2d_1wk.m_std = 13.1;
data.t2d_3mo.m_mean = 112.1;
data.t2d_3mo.m_std = 15.0;
data.t2d_1y.m_mean = 100.8;
data.t2d_1y.m_std = 19.5;
data.ngt_pre.m_mean = 126.6;
data.ngt_pre.m_std = 15.4;
data.ngt_1wk.m_mean = 123.5;
data.ngt_1wk.m_std = 14.7;
data.ngt_3mo.m_mean = 105.5;
data.ngt_3mo.m_std = 13.0;
data.ngt_1y.m_mean = 94.7;
data.ngt_1y.m_std = 16.0;

%
% glucose
%

%  t2d fasting [mmol/L]
data.t2d_pre.glucose_ss_mean = 8.8;
data.t2d_pre.glucose_ss_std  = 2.3;

data.t2d_1wk.glucose_ss_mean = 7.0;
data.t2d_1wk.glucose_ss_std  = 1.2;

data.t2d_3mo.glucose_ss_mean = 6.8;
data.t2d_3mo.glucose_ss_std  = 1.6;

data.t2d_1y.glucose_ss_mean  = 6.2;
data.t2d_1y.glucose_ss_std   = 1.6;

%  ngt fasting [mmol/L]
data.ngt_pre.glucose_ss_mean = 5.5;
data.ngt_pre.glucose_ss_std  = 0.6;

data.ngt_1wk.glucose_ss_mean = 5.0;
data.ngt_1wk.glucose_ss_std  = 0.6;

data.ngt_3mo.glucose_ss_mean = 4.9;
data.ngt_3mo.glucose_ss_std  = 0.4;

data.ngt_1y.glucose_ss_mean  = 4.9;
data.ngt_1y.glucose_ss_std   = 0.3;

%  t2d post-prandial [mM]
data.t2d_pre.glucose_mean = [8.77244 8.77244 8.77244 8.77244 8.85589 9.99010 11.35133 12.11621 12.22632 11.39915 9.31906 7.86372];
data.t2d_pre.glucose_max  = [9.44681 9.44681 9.44681 9.44681 9.59575 10.80851 12.14894 12.82979 13.08511 12.31915 10.27660 8.74468];
data.t2d_pre.glucose_std  = data.t2d_pre.glucose_max - data.t2d_pre.glucose_mean;
data.t2d_pre.glucose_diff = [0 diff(data.t2d_pre.glucose_mean)]./[1 diff(data.t2d_pre.t)];

data.t2d_1wk.glucose_mean = [6.81301 6.81301 6.81301 6.81301 7.52126 9.08133 10.64139 11.09391 9.44337 8.13344 6.70645 6.10303];
data.t2d_1wk.glucose_max  = [7.31915 7.31915 7.31915 7.31915 8.08511 9.63830 11.27660 11.74468 10.19149 8.89362 7.36170 6.61702];
data.t2d_1wk.glucose_std  = data.t2d_1wk.glucose_max - data.t2d_1wk.glucose_mean;
data.t2d_1wk.glucose_diff = [0 diff(data.t2d_1wk.glucose_mean)]./[1 diff(data.t2d_1wk.t)];

data.t2d_3mo.glucose_mean = [6.81301 6.81301 6.81301 6.81301 7.46447 9.81966 11.18089 10.32723 7.96670 6.82716 5.99661 5.64872];
data.t2d_3mo.glucose_max  = [7.31915 7.31915 7.31915 7.31915 8.08511 10.74468 12.04255 11.10638 8.74468 7.55319 6.57447 6.21277];
data.t2d_3mo.glucose_std  = data.t2d_3mo.glucose_max - data.t2d_3mo.glucose_mean;
data.t2d_3mo.glucose_diff = [0 diff(data.t2d_3mo.glucose_mean)]./[1 diff(data.t2d_3mo.t)];

data.t2d_1y.glucose_mean  = [6.15993 6.15993 6.15993 6.15993 7.46441 9.99005 11.09575 9.81607 7.31356 6.23081 5.34337 5.08072];
data.t2d_1y.glucose_max   = [6.72340 6.72340 6.72340 6.72340 8.08511 10.76596 12.06383 10.61702 8.06383 6.87234 5.87234 5.53191];
data.t2d_1y.glucose_std   = data.t2d_1y.glucose_max - data.t2d_1y.glucose_mean;
data.t2d_1y.glucose_diff  = [0 diff(data.t2d_1y.glucose_mean)]./[1 diff(data.t2d_1y.t)];

%  ngt post-prandial [mM]
data.ngt_pre.glucose_mean = [5.48956 5.48956 5.48956 5.48956 5.82918 6.53877 6.90695 6.44993 5.87725 5.58912 5.24061 4.86354];
data.ngt_pre.glucose_max  = [5.68950 5.68950 5.68950 5.68950 6.20091 6.92542 7.37291 6.92542 6.15830 5.83866 5.49772 5.17808];
data.ngt_pre.glucose_std  = data.ngt_pre.glucose_max - data.ngt_pre.glucose_mean;
data.ngt_pre.glucose_diff = [0 diff(data.ngt_pre.glucose_mean)]./[1 diff(data.ngt_pre.t)];

data.ngt_1wk.glucose_mean = [4.92040 4.92040 4.92040 4.92040 5.77227 6.88029 7.64674 7.61655 6.04798 5.19070 4.95606 4.83503];
data.ngt_1wk.glucose_max  = [5.43379 5.43379 5.43379 5.43379 6.43531 7.33029 8.03349 7.99087 6.45662 5.34855 5.34855 5.11416];
data.ngt_1wk.glucose_std  = data.ngt_1wk.glucose_max - data.ngt_1wk.glucose_mean;
data.ngt_1wk.glucose_diff = [0 diff(data.ngt_1wk.glucose_mean)]./[1 diff(data.ngt_1wk.t)];

data.ngt_3mo.glucose_mean = [4.94885 4.94885 4.94885 4.94885 6.25601 8.07541 8.35817 6.93362 4.39752 4.22316 4.64295 4.66440];
data.ngt_3mo.glucose_max  = [5.47641 5.47641 5.47641 5.47641 6.56317 8.67276 8.90715 7.58600 4.79452 4.56012 4.87976 5.05023];
data.ngt_3mo.glucose_std  = data.ngt_3mo.glucose_max - data.ngt_3mo.glucose_mean;
data.ngt_3mo.glucose_diff = [0 diff(data.ngt_3mo.glucose_mean)]./[1 diff(data.ngt_3mo.t)];

data.ngt_1y.glucose_mean  = [4.94885 4.94885 4.94885 4.94885 6.25601 8.21763 8.61427 6.39292 4.11297 4.22332 4.55784 4.66440];
data.ngt_1y.glucose_max   = [5.54033 5.54033 5.54033 5.54033 6.60578 8.67276 8.90715 6.94673 4.45358 4.53881 4.92237 4.92237];
data.ngt_1y.glucose_std   = data.ngt_1y.glucose_max - data.ngt_1y.glucose_mean;
data.ngt_1y.glucose_diff  = [0 diff(data.ngt_1y.glucose_mean)]./[1 diff(data.ngt_1y.t)];

%
% insulin
%

%  t2d fasting [nmol/L]
data.t2d_pre.insulin_ss_mean = 125/1000;
data.t2d_pre.insulin_ss_std  = 77/1000;

data.t2d_1wk.insulin_ss_mean = 73/1000;
data.t2d_1wk.insulin_ss_std  = 32/1000;

data.t2d_3mo.insulin_ss_mean = 58/1000;
data.t2d_3mo.insulin_ss_std  = 35/1000;

data.t2d_1y.insulin_ss_mean  = 47/1000;
data.t2d_1y.insulin_ss_std   = 27/1000;

% ngt fasting [nmol/L]
data.ngt_pre.insulin_ss_mean = 82/1000;
data.ngt_pre.insulin_ss_std  = 28/1000;

data.ngt_1wk.insulin_ss_mean = 49/1000;
data.ngt_1wk.insulin_ss_std  = 14/1000;

data.ngt_3mo.insulin_ss_mean = 43/1000;
data.ngt_3mo.insulin_ss_std  = 14/1000;

data.ngt_1y.insulin_ss_mean  = 36/1000;
data.ngt_1y.insulin_ss_std   = 16/1000;

%  t2d post-prandial [nM]
data.t2d_pre.insulin_mean = [0.13170 0.13170 0.13170 0.13170 0.15222 0.29688 0.38983 0.39742 0.35831 0.27523 0.17372 0.11100];
data.t2d_pre.insulin_max  = [0.16265 0.16265 0.16265 0.16265 0.19105 0.37952 0.49828 0.50861 0.41824 0.32272 0.20912 0.14200];
data.t2d_pre.insulin_std  = data.t2d_pre.insulin_max - data.t2d_pre.insulin_mean;
data.t2d_pre.insulin_rel  = data.t2d_pre.insulin_mean - data.t2d_pre.insulin_mean(1);

data.t2d_1wk.insulin_mean = [0.05411 0.05411 0.05411 0.05411 0.14963 0.29947 0.53983 0.53191 0.26261 0.14850 0.08320 0.07738];
data.t2d_1wk.insulin_max  = [0.08778 0.08778 0.08778 0.08778 0.18847 0.38210 0.68158 0.69707 0.31239 0.17040 0.10843 0.10069];
data.t2d_1wk.insulin_std  = data.t2d_1wk.insulin_max - data.t2d_1wk.insulin_mean;
data.t2d_1wk.insulin_rel  = data.t2d_1wk.insulin_mean - data.t2d_1wk.insulin_mean(1);

data.t2d_3mo.insulin_mean = [0.05153 0.05153 0.05153 0.05153 0.17291 0.45206 0.72604 0.58363 0.23158 0.10712 0.05734 0.05152];
data.t2d_3mo.insulin_max  = [0.08778 0.08778 0.08778 0.08778 0.19105 0.53184 0.86231 0.69707 0.28399 0.14716 0.08262 0.07229];
data.t2d_3mo.insulin_std  = data.t2d_3mo.insulin_max - data.t2d_3mo.insulin_mean;
data.t2d_3mo.insulin_rel  = data.t2d_3mo.insulin_mean - data.t2d_3mo.insulin_mean(1);

data.t2d_1y.insulin_mean  = [0.04894 0.04894 0.04894 0.04894 0.14446 0.37447 0.58897 0.42328 0.15141 0.07351 0.04182 0.03342];
data.t2d_1y.insulin_max   = [0.08778 0.08778 0.08778 0.08778 0.18847 0.44148 0.68675 0.53959 0.18847 0.09811 0.06454 0.05680];
data.t2d_1y.insulin_std   = data.t2d_1y.insulin_max - data.t2d_1y.insulin_mean;
data.t2d_1y.insulin_rel   = data.t2d_1y.insulin_mean - data.t2d_1y.insulin_mean(1);

%  ngt post-prandial [nM]
data.ngt_pre.insulin_mean = [0.04339 0.04339 0.04339 0.04339 0.14100 0.41646 0.51149 0.41065 0.25279 0.14389 0.07045 0.04854]
data.ngt_pre.insulin_max  = [0.09840 0.09840 0.09840 0.09840 0.22032 0.49717 0.58856 0.47105 0.36513 0.18173 0.09899 0.07492];
data.ngt_pre.insulin_std  = data.ngt_pre.insulin_max - data.ngt_pre.insulin_mean;
data.ngt_pre.insulin_rel  = data.ngt_pre.insulin_mean - data.ngt_pre.insulin_mean(1);

data.ngt_1wk.insulin_mean = [0.05886 0.05886 0.05886 0.05886 0.14358 0.42161 0.68674 0.64776 0.26827 0.07688 0.05756 0.04082];
data.ngt_1wk.insulin_max  = [0.09840 0.09840 0.09840 0.09840 0.20623 0.49952 0.83270 0.76448 0.36278 0.09958 0.07551 0.05614];
data.ngt_1wk.insulin_std  = data.ngt_1wk.insulin_max - data.ngt_1wk.insulin_mean;
data.ngt_1wk.insulin_rel  = data.ngt_1wk.insulin_mean - data.ngt_1wk.insulin_mean(1);

data.ngt_3mo.insulin_mean = [0.05887 0.05887 0.05887 0.05887 0.27760 0.93965 1.32333 1.01117 0.20897 0.07433 0.04210 0.03309];
data.ngt_3mo.insulin_max  = [0.10075 0.10075 0.10075 0.10075 0.31656 1.14271 1.62612 1.29264 0.36043 0.09723 0.06143 0.04440];
data.ngt_3mo.insulin_std  = data.ngt_3mo.insulin_max - data.ngt_3mo.insulin_mean;
data.ngt_3mo.insulin_rel  = data.ngt_3mo.insulin_mean - data.ngt_3mo.insulin_mean(1);

data.ngt_1y.insulin_mean  = [0.05371 0.05371 0.05371 0.05371 0.25183 0.60202 0.89293 0.45703 0.06981 0.03308 0.02664 0.01761];
data.ngt_1y.insulin_max   = [0.09840 0.09840 0.09840 0.09840 0.23910 0.67792 1.02049 0.53912 0.09048 0.06201 0.04030 0.03267];
data.ngt_1y.insulin_std   = data.ngt_1y.insulin_max - data.ngt_1y.insulin_mean;
data.ngt_1y.insulin_rel   = data.ngt_1y.insulin_mean - data.ngt_1y.insulin_mean(1);

%
% c-peptide
%

%  t2d fasting [nmol/L]
data.t2d_pre.cpeptide_ss_mean = 1483/1000;
data.t2d_pre.cpeptide_ss_std  = 543/1000;

data.t2d_1wk.cpeptide_ss_mean = 1175/1000;
data.t2d_1wk.cpeptide_ss_std  = 595/1000;

data.t2d_3mo.cpeptide_ss_mean = 1049/1000;
data.t2d_3mo.cpeptide_ss_std  = 501/1000;

data.t2d_1y.cpeptide_ss_mean  = 796/1000;
data.t2d_1y.cpeptide_ss_std   = 345/1000;

%  ngt fasting [nmol/L]
data.ngt_pre.cpeptide_ss_mean = 1098/1000;
data.ngt_pre.cpeptide_ss_std  = 227/1000;

data.ngt_1wk.cpeptide_ss_mean = 834/1000;
data.ngt_1wk.cpeptide_ss_std  = 187/1000;

data.ngt_3mo.cpeptide_ss_mean = 816/1000;
data.ngt_3mo.cpeptide_ss_std  = 191/1000;

data.ngt_1y.cpeptide_ss_mean  = 602/1000;
data.ngt_1y.cpeptide_ss_std   = 198/1000;

%  t2d post-prandial [nM]
data.t2d_pre.cpeptide_mean = [1.56164 1.56164 1.56164 1.56164 1.59817 1.94521 2.23744 2.48402 2.72146 2.70320 2.27397 1.78995];
data.t2d_pre.cpeptide_max  = [1.73183 1.73183 1.73183 1.73183 1.77682 2.21394 2.54165 2.75994 2.90467 2.93090 2.53652 2.02361];
data.t2d_pre.cpeptide_std  = data.t2d_pre.cpeptide_max - data.t2d_pre.cpeptide_mean;
data.t2d_pre.cpeptide_rel  = data.t2d_pre.cpeptide_mean - data.t2d_pre.cpeptide_mean(1);

data.t2d_1wk.cpeptide_mean = [1.12329 1.12329 1.12329 1.12329 1.45205 2.01826 2.94977 3.36073 2.92237 2.42922 1.86301 1.58904];
data.t2d_1wk.cpeptide_max  = [1.38532 1.38532 1.38532 1.38532 1.58535 2.38721 3.24378 3.88151 3.34236 2.75766 2.09883 1.76829];
data.t2d_1wk.cpeptide_std  = data.t2d_1wk.cpeptide_max - data.t2d_1wk.cpeptide_mean;
data.t2d_1wk.cpeptide_rel  = data.t2d_1wk.cpeptide_mean - data.t2d_1wk.cpeptide_mean(1);

data.t2d_3mo.cpeptide_mean = [1.04110 1.04110 1.04110 1.04110 1.38813 2.37443 3.06849 3.44292 2.54795 2.08219 1.44292 1.26027];
data.t2d_3mo.cpeptide_max  = [1.36712 1.36712 1.36712 1.36712 1.59445 2.69723 3.48086 3.89064 2.83172 2.34732 1.67026 1.44002];
data.t2d_3mo.cpeptide_std  = data.t2d_3mo.cpeptide_max - data.t2d_3mo.cpeptide_mean;
data.t2d_3mo.cpeptide_rel  = data.t2d_3mo.cpeptide_mean - data.t2d_3mo.cpeptide_mean(1);

data.t2d_1y.cpeptide_mean  = [0.77626 0.77626 0.77626 0.77626 1.29680 2.18265 2.85845 2.73973 1.98174 1.63470 1.11416 0.88584];
data.t2d_1y.cpeptide_max   = [1.00234 1.00234 1.00234 1.00234 1.54885 2.35072 3.22554 3.02438 2.20255 1.85494 1.25992 0.97496];
data.t2d_1y.cpeptide_std   = data.t2d_1y.cpeptide_max - data.t2d_1y.cpeptide_mean;
data.t2d_1y.cpeptide_rel   = data.t2d_1y.cpeptide_mean - data.t2d_1y.cpeptide_mean(1);

%  ngt post-prandial [nM]
data.ngt_pre.cpeptide_mean = [1.13338 1.13338 1.13338 1.13338 1.44380 2.21150 2.68655 2.65853 2.22752 1.86966 1.43750 1.08765];
data.ngt_pre.cpeptide_max  = [1.18826 1.18826 1.18826 1.18826 1.55354 2.37618 2.82374 2.83232 2.42874 2.09832 1.61126 1.17911];
data.ngt_pre.cpeptide_std  = data.ngt_pre.cpeptide_max - data.ngt_pre.cpeptide_mean;
data.ngt_pre.cpeptide_rel  = data.ngt_pre.cpeptide_mean - data.ngt_pre.cpeptide_mean(1);

data.ngt_1wk.cpeptide_mean = [0.84069 0.84069 0.84069 0.84069 1.34317 2.39446 3.39996 3.52744 2.72141 1.80563 1.28200 1.03279];
data.ngt_1wk.cpeptide_max  = [0.94132 0.94132 0.94132 0.94132 1.55353 2.69629 3.89386 4.00305 3.19703 2.08917 1.35517 1.09681];
data.ngt_1wk.cpeptide_std  = data.ngt_1wk.cpeptide_max - data.ngt_1wk.cpeptide_mean;
data.ngt_1wk.cpeptide_rel  = data.ngt_1wk.cpeptide_mean - data.ngt_1wk.cpeptide_mean(1);

data.ngt_3mo.cpeptide_mean = [0.84986 0.84986 0.84986 0.84986 1.87369 3.55603 5.00970 4.76219 2.71229 1.60441 1.04421 0.88643];
data.ngt_3mo.cpeptide_max  = [0.94131 0.94131 0.94131 0.94131 1.99256 3.93105 5.68653 5.39328 2.46532 1.88796 1.18141 0.95961];
data.ngt_3mo.cpeptide_std  = data.ngt_3mo.cpeptide_max - data.ngt_3mo.cpeptide_mean;
data.ngt_3mo.cpeptide_rel  = data.ngt_3mo.cpeptide_mean - data.ngt_3mo.cpeptide_mean(1);

data.ngt_1y.cpeptide_mean  = [0.59376 0.59376 0.59376 0.59376 1.44378 2.81516 4.03105 3.30792 1.52325 1.09224 0.69665 0.55716];
data.ngt_1y.cpeptide_max   = [0.80413 0.80413 0.80413 0.80413 1.55354 3.08958 4.37860 3.72866 1.69704 1.22029 0.77898 0.61205];
data.ngt_1y.cpeptide_std   = data.ngt_1y.cpeptide_max - data.ngt_1y.cpeptide_mean;
data.ngt_1y.cpeptide_rel   = data.ngt_1y.cpeptide_mean - data.ngt_1y.cpeptide_mean(1);