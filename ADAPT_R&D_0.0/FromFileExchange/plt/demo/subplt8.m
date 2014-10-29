% subplt8.m ----------------------------------------------------------
%
% - This script shows a slight expansion of the ideas found in subplt.m
% by increasing the number of axes from 3 to 8. Also the axes are
% arranged in two columns which allows the use of two different x axes
% (one for each column).
% - Note that the four axes on the left are synchronized with each other
% as well as the four on the right, although the left and right halves
% are independent of each other and have different x axis limits and units.
% - The main plot (lower left) contains 3 traces because 10 traces have
% been defined and 7 of them are assigned to the other 7 subplots. The
% main plot doesn't have a right hand axis in this example, although it
% would if a 'Right' argument was included or if an extra y-label were
% included in the 'LabelY' array.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

x = 0:600;  t = x/600;  z = (x-400)/30;  t2 = t*12;
v = 1:2:11;  w = 1:11;  r = (-1).^(0:5)./(v.^2);
square   = (4./v)*sin(4*pi*v'*t);
sawtooth = (2./w)*sin(4*pi*w'*(t+pi));
triangle = 2*r*sin(4*pi*v'*t);
serp     = 18*z ./ (1 + z.^2);
sweep    = 2 - 4*exp(-1.4*t).*sin(10*pi*t.^5);
cost3    = t .* cos(5*pi*(1-t).^3);
sin1x    = 8.5*sin(1./(2*t+.1));
bell2    = 85 * (exp(-((x-200)/30).^2) - exp(-z.^2));
poly3    = 24*t.^3 - 30*t.^2 + 8*t;

plt(x,[square; sawtooth; triangle; sweep; serp; humps(t);],...
    t2,[sin1x; bell2; poly3; cost3;],'FigName','subplt8',...
   'TraceID',{'Square' 'Saw' 'Triangle'},'FigBKc',[.2 .2 .2],...
   'LabelX',{'seconds' '\mumeters'},'LabelY',...
   {'Fourier Series' 'sweep' 'serp' 'humps' 'sin1x' 'bell2' 'poly3' 'cost3'},...
   'Options','S-Y','SubPlot',[40 20 20 20 -50 20 20 20 40]);

