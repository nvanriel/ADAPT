% movbar.m
%
% movbar plots a series of 40 random bars and displays a horizontal threshold
% line which you can move by sliding the mouse along the vertical green line.
% As you move the threshold line, a string below the plot reports the number
% of bars that exceed the threshold. (This demonstrates the use of the plt
% xstring parameter.)
%
% These two buttons are added to the figure ---
% Rand: Sets the bar heights to a new random data set.
% Walk: Clicking this once starts a random walk process of the bar heights.
%       Clicking a second time halts this process.
%       The Walk button user data holds the walk/halt status (1/0 respectively)
%       demonstrating a simple way to start and stop a moving plot.
%
% Note that you can move the threshold or press the Rand button while it is
% walking. Also if you click on one of the vertical purple bars, the horizontal
% threshold bar will then follow the upper end of that vertical bar. If an input
% argument is provided, movbar will start as if the walk button has been hit.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org


function movbar(in1);
  u = ones(1,999);
  S.tr = plt('FigName','movbar',-u,cumsum(u),...         % Line 1 is vertical slider (green)
             vdata,'LineWidth',{4 6},'xlim',[-2 42],...  % Line 2 is the random bars (purple)
             'xstring',@xstr);                           % enable xstring parameter
  S.cid = getappdata(gcf,'cid');
  S.hz  = line([0 41],[500 500],'color',[0 1 0]);        % create horizontal threshold line
  S.rnd = uicontrol('pos',[10 420 40 25],'string','Rand','Callback',{@btn,1}); % create Rand button
  S.wlk = uicontrol('pos',[10 380 40 25],'string','Walk','Callback',{@btn,0}); % create Walk button
  S.tx  = text(-.5,980,...
        '\leftarrow click/drag on this green line to move the horizontal threshold',...
        'color',[0 1 .6]);
  set(gcf,'user',S);                                     % save for callbacks
  set(findobj('tag','xstr'),'string',xstr);              % initialize xstring
  if nargin btn(0,0,0); end;                             % walk if input argument provided
% end function movbar

function t = xstr()  % xstring function, move threshold bar
  S = get(gcf,'user');
  if ishandle(S.tx) delete(S.tx); end;
  xy = plt('cursor',S.cid,'get','position');  y = imag(xy);
  set(S.hz,'y',[y y]);
  t = sprintf('%d bars > %d',sum(get(S.tr(2),'y') > y),y); % count bars above threshold
% end function xstr

function btn(h,arg2,r)  % rand and walk button callbacks
  S = get(gcf,'user');
  if r walk(S.tr(2),0);
  else if findstr('S',get(S.wlk,'string')) t = 'Walk'; else t = 'Stop'; end; % toggle Walk/Stop 
       set(S.wlk,'string',t);
       while ishandle(S.wlk) & findstr('S',get(S.wlk,'string'))
             walk(S.tr(2)); % walk until button pressed again
       end;
  end;
% end function btn

function walk(h,r) % set the y data for line h (rand button use 2 argument form)
  y = imag(vdata)';                              % compute a random y vector
  if nargin==1 y = get(h,'y') + (y-500)/20; end; % for walk button
  set(h,'y',y);                                  % update line data
  plt('cursor',getappdata(gcf,'cid'),'mainCur',0); % update xstring
  drawnow;
% end function walk

function v = vdata()       % generate some data to plot
  x = 1:40;                % plot 40 bars
  y = 1000*rand(size(x));  % some random data to plot
  v = Pvbar(x,0,y);        % vertical bars
% end function vdata