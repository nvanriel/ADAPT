% plt50.m ------------------------------------------------------------
%
% This script is similar to plt5.m except the number of functions plotted has
% been increased to 50 to demonstrate the use of the TIDcolumn parameter.
% Normally the legend is rendered in a single column; but with this many
% traces, the trace IDs fit much more comfortably in two columns. The
% 'TIDcolumn',25 included in the plt argument list actually specifies the
% number of items to put in the second column, which in this example means
% that both columns will contain 25 items.
% 
% With so many traces, the utility of using the legend to selectively enable
% or disable individual traces becomes even more compelling. Although the
% traces and the legend are color coded, it's difficult to distinguish every
% trace based on color, so clicking on a legend item is often necessary
% to uniquely identify a trace. This also is essential when you need to reduce
% the clutter that often results from plotting so many traces.
%
% The 'Position' parameter is used to increase the figure area about 30%
% from the default of 700x525 pixels to 830x550 to make the plot less crowded.
%
% The 'HelpFileR' parameter is used to specify which help file will appear
% when you right click on the Help tag in the menu box. Normally the file
% specified will contain help for the currently running script. In this case
% prin.pdf is just used as an example and in fact has nothing to do with plt50.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

t  = (0:399)/400;  u = 1-t;             % create the x-axis data
y1 = 8.3 - 1.4*exp(-6*t).*sin(70*t);    % prototype for traces 1-10
y2 = 2 * t .* cos(15*u.^3) + 6;         % prototype for traces 11-20
y3 = 5 - 2*exp(-1.4*t).*sin(30*t.^5);   % prototype for traces 21-30
y4 = u .* sin(20*u.^3) + 3;             % prototype for traces 31-40
y5 = (y1+y2+y3+y4)/2 - 10;              % prototype for traces 41-50
w = ones(10,1);  s = 5.3*(t-.5);        % used to expand 5 traces into 50
v = repmat((10-cumsum(w))*(sqrt(16-s.*s)-3)/6,5,1);
y = [y1(w,:);y2(w,:);y3(w,:);y4(w,:);y5(w,:)] + v;  % plot y (50 x 400 matrix)
plt(t,y,'FigName','plt50','Position',[10 50 830 550],...
        'TIDcolumn',25,'HelpFileR','prin.pdf');
