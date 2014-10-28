% plt5.m ------------------------------------------------------------
% This is a simple script which creates a plot containing 5 traces.
% Run this script as you review the help documentation.
% Note how the 5 y vectors are combined to form a single plt argument.
% Note the use of the following optional arguments:
% - 'Xlim' and 'Ylim' to control the initial axis limits.
% - 'FigName' to name the figure that contains the plot
% - 'Right' to assign trace 3 to the right hand axis.
% - 'LabelX' to assign a label for the x axis
% - 'LabelY' to assign a label for both the left and right-hand y axes
% Note that plt will use a right hand axis since two labels were included
% in the LabelY parameter. Usually the 'Right' parameter is included
% to specify which traces are to use the right axis, but in this example
% the parameter was omitted, so plt defaults to putting just the last
% trace on the right hand axis.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

t  = (0:399)/400; x = (t+.08)*1e-5;
y1 = 5 - 1.4*exp(-2*t).*sin(20*t);
y2 = repmat([1 0 1 0 1 0]+3.5,100,1); y2 = y2(:)';
f = (0:.15:25)-12.5; f = sin(f)./f;
y2 = filter(f,sum(f),y2); y2(1:200) = [];
y3 = 3 * t .* cos(5*pi*(1-t).^3) + 3;
y4 = 2.2 - 2*exp(-1.4*t).*sin(10*pi*t.^5);
plt(x,[y1; y2; y3; y4; humps(t)],'FigName','plt5',...
   'Xlim',x([1 end]),'Ylim',[1.1 6],'LabelX','seconds',...
   'LabelY',{'Lines 1 thru 4' 'Humps function'});
