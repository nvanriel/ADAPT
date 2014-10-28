% subplt.m ----------------------------------------------------------
%
% - The 'SubPlot' argument is used to create 3 axes. plt puts a single
% trace on each axes except for the main (lower) axis which gets
% all the remaining traces. In this case, since there are 5 traces
% defined, the main axis has 3 traces. Note that the traces are
% assigned to the axes from the bottom up so that the last trace
% (serp) appears on the upper most axis.
% - The 'LabelY' argument defines the y-axis labels for all three axes,
% again from the bottom up. You can also define the y-axis label for
% the right hand main axis, by tacking it onto the end of the LabelY
% array (as done here)
% - The 'Right',2 argument is used to specify that the 2nd trace of
% the main axis should be put on the right hand axis. If this argument
% was omitted, plt would still have known that a right hand axis was
% desired (because of the extra y-label in the LabelY array) however
% it would have put trace 3 on the right hand axis. (By default, the
% last trace goes on the right axis).
% - The Linewidth and LineStyle arguments define line characteristics
% for all 5 traces.
% - The TraceMK parameter enables the traceID box to show the line
% characteristics and the AxisPos parameter widens the traceID box to
% make room for this.
% - Note that the lower (main) axis has all the usual plt cursoring
% features. The other 2 plots support a subset of the cursoring features
% and have individual color coded y-value cursor readouts shown along
% the bottom portion of the figure.
% - Only a single x-axis edit box is needed since plt keeps the
% cursors of all three axes aligned. Also note that if you zoom or
% pan any of the 3 plots, the other two plots will adjust their x-axis
% limits to agree.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

x = 0:600;   t = x/600;  z = (x-400)/30;
v = 1:2:11;  w = 1:11;   r = (-1).^(0:5)./(v.^2);
square   = (4./v)*sin(4*pi*v'*t);
sawtooth = (60./w)*sin(4*pi*w'*(t+pi));
triangle = 2*r*sin(4*pi*v'*t);
serp     = 18*z ./ (1 + z.^2);
sweep    = 2 - 4*exp(-1.4*t).*sin(10*pi*t.^5);

plt(x,[square; sawtooth; triangle; sweep; serp],'Right',2,...
   'FigName','subplt','Options','S-Y','GRIDc',[1 1 -1]/4,'GRIDstyle',':',...
   'LabelX','seconds','LabelY',{'Fourier Series' 'Sweep' 'Serp' 'Sawtooth'},...
   'SubPlot',[50 30 20],'AxisPos',[1 1 1 1 1.5],'FigBKc',1./[9 12 9],...
   'Linewidth',{1 3 3 1 3},'LineStyle',{'-' '-' ':' '-' '--'},...
   'TraceID',{'Square' 'Saw' 'Tri'},'TraceMK',[.65 .95]);
