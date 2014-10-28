% bounce.m -----------------------------------------------------------
%
% - This function displays a specified number of markers with random
%   shapes and colors in the form of a 5 pedal rose which then start
%   randomly walking around bouncing off the walls. Click on the
%   "Walk"/"Stop" button to start and stop the motion.
%   The slider controls the walking speed.
% - The argument determines the number of markers, i.e. bounce(88)
%   will display 88 markers. If bounce is called without an argument,
%   the default value will be used (128 markers).
% - Shows that plt can create many line objects by using matrices
%   for the x,y parameters. (Each marker is actually a line object.)
% - Shows how plt can set line properties using cell arrays.
% - Shows how plt can avoid its 99 trace limit by disabling TraceIDs.
%
% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function bounce(n)
  if ~nargin n=128; end;             % default number of markers
  colors  = {'red';'green';'blue';'yellow';'magenta';'none'}; % marker colors
  markers = {'o';'>';'<';'^';'v';'x';'+';'square';'diamond'}; % marker styles
  t = 0:pi/n:pi;  t(end)=[];  r = sin(5*t)/2; % 5 pedal rose in parametric form
  x = [r.*cos(t); t+NaN; t+NaN];   % 1st row contains marker x position
  y = [r.*sin(t); rand(2,n)-.5];   % 1st row contains marker y position
                                   % 2nd/3rd rows contains marker x/y speed
  S.mk = plt(x,y,'FigName','Bounce','TraceID',[],'LabelX','','LabelY','',...
    'Options','Ticks','Xlim',[-.5 .5],'Ylim',[-.5 .5],...
    'TraceC',[.2 .6 1],'XYaxc',[.3 .3 .3],'markersize',10,...
    'MarkerFaceColor',colors(ceil(6*rand(1,n))),...  % random face color
    'MarkerEdgeColor',colors(ceil(5*rand(1,n))),...  % random edge color
    'Marker',        markers(ceil(9*rand(1,n))));    % random marker type
  S.sli = uicontrol('style','slider','units','norm','pos',[.04 .5 .02 .3],...
                    'value',.01,'min',.0005,'max',.05);
  btn = uicontrol('units','norm','pos',[.02 .9 .07 .04],'callback',{@walk,S});
  set([text(-.63,-.06,'slow') text(-.63,.33,'fast')],...
      'color',[.7 .7 .7],'units','norm');
  pause(min(2,n/128));  % time to look at initial configuration
  walk(btn,0,S); % start it going (forever)
% end function bounce

function walk(btn,arg2,S)                    % Walk button callback ---------
  if get(btn,'user') set(btn,'user',0,'string','Walk');
  else               set(btn,'user',1,'string','STOP');
  end;                                       % toggle walk/stop button
  while ishandle(btn) & get(btn,'user')      % while walking do ...
    s = get(S.sli,'value');                  % get speed
    for k=1:length(S.mk)                     % loop over all markers
      m=S.mk(k); x=get(m,'x'); y=get(m,'y'); % get x/y position
      if length(y) < 3 continue; end;        % skip cursor
      p = [x(1) y(1)] + s*y(2:3);            % position after linear translation
      v = y(2:3) .* (1 - 2*(abs(p)>.5));     % velocity after bouncing off edges
      set(m,'x',[p(1) x(2:3)],'y',[p(2) v]); % save new positions & speeds
    end;
  drawnow;
  end;  % end while
% end function walk
