% circles12.m -------------------------------------------------------------------
%
% This is a two part script. The first part creates 3 figures
% each showing a different solution to the following problem:
%
%      *****************************************************
%      *****************************************************
%      **                                                 **
%      **            The 12 circle problem:               **
%      **    Draw 12 circles in a plane so that every     **
%      **    circle is tangent to exactly 5 others.       **
%      **                                                 **
%      *****************************************************
%      *****************************************************
%
% - Demonstrates the utility of using complex numbers to
%   hold the x and y positions of the plotted points.
%
% - Demonstrates 2 ways of creating the Trace IDs (reshape & repmat).
%
% - Demonstrates how to make circles look true by using a zero in the
%  'Position' argument (width or height).
%
% - Note that even though the calls to plt for solutions 2&3 specify
%   same screen location ('Position' parameter) plt doesn't actually
%   plot them on top of each other. Instead a small offset is added
%   in this situation, a feature that makes it easier to create
%   many plt windows so that any of them can be easily selected
%   with the mouse.
%
% - The last figure shows the use of the Nocursor and -All options
%   to make the cursor objects and menu box items invisible.

%
% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

N = 600;                        % number of points per circle
cN = exp((1:N)*pi*2i/(N-1))';   % N point unit circle
% Solution #3 ------------------------------------------------------
v = 1:4;  r = (12+5*v)./(12-v); % radii of vertical set of 4
c = [v-1 9-v complex(4,7-r)];   % center location of all 12 circles
r = [v v r];                    % radii of all 12 circles
sz = get(0,'screensize');
plt(cN*r + repmat(c,N,1),'FigName','12 Circles (solution 3)',...
    'LineWidth',2,'Options','Ticks','Position',[10 sz(4)-725 620 648],...
    'Xlim',[-1.6  9.5],'Ylim',[-4.8 7.5],...
    'AxisPos',[1 1 1 1 1.2],'LabelY','','LabelX','',...
    'TraceID',prin('{circle%d!row}',1:12));
% Solutions #1 and 2 ----------------------------------------------
% Note: there are 2 more solutions that are essentially combinations of
%       solutions #1 and #2. If you find yet more solutions, please let me know!
ID = prin('middle ~, outer ~, {group%d!row}',[1 1 1 1 1 2 2 2 2 2]);
pi5 = pi/5;  s = 1/sin(pi5);  u5 = ones(1,5);
c5 = exp((0:4)*pi5*2i);                      % 5 point unit circle
rg1 = 1/(s-1);                               % radius of group 1 circles
t = 1 + 2*rg1;
rg2 = roots([s^2-1, -2*(s*sqrt(t)+rg1), t]); % radius of group 2 circles
b = c5*s*rg1*exp(pi5*1i);
for k = [2 1]
  c = [0 0 b c5*s*rg2(k)];                   % center location of all 12 circles
  r = [1 rg2(k)*(s+1) rg1*u5 rg2(k)*u5];     % radii of all 12 circles
  plt(cN*r + repmat(c,N,1),'LabelY','','LabelX','',...
     'FigName',sprintf('12 Circles (solution %d)',k),'Options','Ticks',...
     'TraceID',ID,'LineWidth',2,'Position',[10 50 600 0]);
end;

% The second part of this script (below) draws the solution to the
% following problem:
%
%      ********************************************************
%      ********************************************************
%      **                                                    **
%      **   Divide a circle into n congruent parts so that   **
%      **   at least one part does not touch the center.     **
%      **   (Hint: the only known solution uses n = 12)      **
%      **                                                    **
%      ********************************************************
%      ********************************************************
%
% A slider is also added below the plot which lets you rotate the
% image and control the rotation speed
%

N6 = N/6;  f = 1:6;  na = NaN+f;  cN = cN';
a = repmat([3 4 5 6 1 2]*N6,N6,1);     % index points for arc centers
d = cN + cN(a(:));                     % N point circle with translated centers
e = [reshape(transpose(d),N6,6); na];  % insert NaNs to eliminate stray lines
f = [na; cN(N6*f); d(N6*(f-.5))];      % draw the lines bisecting the 6 congruent parts
e = [e(:)' f(:)'];                     % append the bisecting lines to the 6 arcs
h = plt(e,cN,'Position',[645 sz(4)-477 0 400],'Figname','12 circles (part 2)',...
        'Options','Ticks Nocur -All','TraceID',['div ';'circ'],...
        'LabelX','','LabelY','','Xlim',[-1.1 1.1],'Ylim',[-1.1 1.1]);
set(gca,'xtick',[],'ytick',[]);                 % remove tick marks
he = plt('edit','pos',[-.75,-1.23],'value',1,'min',-15,'max',15); % create rotation speed control
ht = text(-1.42,-1.23,'Rotation speed:','color',[.6 .6 .6]);  % label for above
% create the close button with a callback that deletes itself
bt = uicontrol('str','Stop','units','norm','position',[.35 .02 .08 .05],...
               'callback','delete(findobj(gcf,''str'',''Stop''))');
while ishandle(bt)           % forever loop (until you click on the stop button)
  s = plt('edit',he,'get','value');
  if s  if s<0 s=s+N-1; end; % rotate CCW/CW for Positive/Negative slider position
        e = e .* cN(round(s));
        set(h(1),'x',real(e),'y',imag(e));
  end;
  pause(.02);
end;
if ishandle(he) set([he ht],'vis','off'); end; % hide edit control and its label
