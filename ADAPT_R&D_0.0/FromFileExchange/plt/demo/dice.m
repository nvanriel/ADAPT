% dice.m -----------------------------------------------------------
% Simulation of the Sam Loyd's Carnival Dice game:
% -  You bet 1 dollar to play. You then roll 3 dice
% -  If one six appears you get 2 dollars
% -  If two sixes appear, you get 3 dollars
% -  If three sixes appear, you get 4 dollars
% -  Otherwise, you get nothing 
% Is this a good bet to make?

% Three traces are created:
%     - accumulated winnings
%     - earnings per bet
%     - expected earnings per bet
%
% The first two traces are displayed as they are computed, i.e. every time the
% dice are rolled, a new value is appended to the trace and the plot is updated
% so you can watch the function grow in real time.
%
% A second axis is added near the top of the figure to show the dice. For
% each die, a line with dots as markers is added for each of the six faces,
% with only one of these lines being visible at a time. A square patch is
% also added for each die for the visual effect.

% dice()  - sets up simulation. No bets are placed until you click on a button.
% dice(n) - sets up simulation & makes n bets.
% dice(0) - sets up simulation & makes bets continously until you click stop.


% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function dice(in1)
  S.tr = plt(0,[0 0 0],'FigName','3 dice problem','Options','-Y-XTicks',...
    'Xlim',[0 100],'Ylim',[-10,10],'YlimR',[-.15 .05],'Right',[2 3],...
    'LabelX','# of bets','LabelY',{'Accumulated winnings' 'Earnings per bet'},...
    'TraceID',{'Accum' 'per bet' 'expect'},...
    'TraceC',[0 1 0; 1 0 1; .3 .3 .3],'AxisPos',[1 1 1 .85]);
  c = get(gcf,'color');
  S.ax = getappdata(gcf,'axis');
  axes('units','norm','pos',[.5 .88 .38 .1],...
            'color',c,'xcolor',c,'ycolor',c,'xlim',[0 5]);
  patch([0 2 4; 1 3 5; 1 3 5; 0 2 4],[zeros(2,3); ones(2,3)],[0 .2 .3]);
  S.tx = text(5.5,.4,' ','color',[0 .7 1],'fontsize',28);
  cx = .5;  cy = .5;  e = .3;
  for k = 1:3  % draw all possible rolls for each of 3 die
    S.d(k,1) = line(cx,                   cy);                  % one dot
    S.d(k,2) = line(cx+[-e e],            cy+[-e e]);           % two dots
    S.d(k,3) = line(cx+[-e 0 e],          cy+[-e 0 e]);         % three dots
    S.d(k,4) = line(cx+[-e e e -e],       cy+[-e -e e e]);      % four dots
    S.d(k,5) = line(cx+[-e e e -e 0],     cy+[-e -e e e 0]);    % five dots
    S.d(k,6) = line(cx+[-e -e -e e e e],  cy+[-e 0 e -e 0 e]);  % six dots
    cx = cx + 2;
  end;
  set(S.d,'vis','off','linestyle','none','marker','s','color',[1 1 .5],...
      'linewidth',3,'markersize',4);
  S.sli  = uicontrol('style','slider','value',0.95);
  S.betC = uicontrol('CallBack',{@btn,S,1  });
  S.bet1 = uicontrol('CallBack',{@btn,S,0});
  S.clr  = uicontrol('CallBack',{@btn,S,-1});
  set([S.bet1 S.betC S.clr S.sli],...
      {'Position'},{[90 490 50 22]; [170 490 70 22]; [270 490 40 22]; [135 460 175 18]},...
      'Units','Norm',{'String'},{'1 bet'; 'Continuous'; 'Clear'; '';});
  text(-4.9,.15,'Speed','color',[.5 .5 .5]);
  w = -6^3;      % cost of placing all possible bets
  w = w + 2*75;  % 75 ways to win 2 dollar
  w = w + 3*15;  % 15 ways to win 3 dollars
  w = w + 4*1;   % 1  way  to win 4 dollars
  set(S.tr(3),'x',[0 1e9],'y',[w w]/6^3); % set earnings/bet expected value (trace3)
  if nargin
    if ~in1 btn(0,0,S,1); end;       % for dice(0), click the continuous button
    for k = 1:in1 btn(0,0,S,0); end; % otherwise click the 1bet button in1 times
  end;
% end function dice

function btn(h,arg2,S,arg4) % button callbacks -------------------------------------------
  if ~isfield(S,'betC') S.betC = h; end;
  t = get(S.betC,'string');
  set(S.betC,'string','Continuous');  % stop if it was running
  if arg4==-1                         % clear button comes here ---------
     set(S.tr(1:2),'x',0,'y',0);      % reinitialize the data and axis limits
     set(S.ax(1),'xlim',[0 100],'ylim',[-10 10]);
     set(S.ax(2),'xlim',[0 100],'ylim',[-.15 .05]);
     return;
  end;
  if t(1)=='S' return; end; % If it was running (continuous) we are done
  x = get(S.tr(1),'x'); xe = x(end);  % single or continuous betting comes here
  y = get(S.tr(1),'y'); ye = y(end);
  y1 = min(y);  y2 = max(y);
  yr  = get(S.tr(2),'y');
  set(S.betC,'string','Stop');
  while ishandle(S.betC)& strcmp(get(S.betC,'string'),'Stop')
    if ~arg4 set(S.betC,'string','Continuous'); end; % do just one bet
    set(S.d,'vis','off');               % turn all the faces off
    r = ceil(rand(1,3)*6);              % roll the 3 dice
    set([S.d(1,r(1)) S.d(2,r(2)) S.d(3,r(3))],'vis','on');
    r = sum(r==6);  if ~r r=-1; end;    % earnings for this bet
    set(S.tx,'string',num2str(r));      % show the earnings
    xe = xe + 1;  x = [x xe];           % advance the x-axis by 1 bet
    ye = ye + r;  y = [y ye];           % add the earnings to accumulated winnings
    set(S.tr(1),'x',x,'y',y);
    xlim = get(S.ax(1),'xlim');
    if xe > xlim(2) set(S.ax,'xlim',[0 xlim(2)+200]); end;
    y1 = min(y1,ye);  y2 = max(y2,ye);
    set(S.ax(1),'ylim',10*[floor(min(y1,-10)/10) ceil(max(y2,10)/10)]);
    yr = [yr ye/xe];                    % add earnings/bet to line 2 on the right hand axis
    set(S.tr(2),'x',x,'y',yr);
    yb = yr(max(end-100,1):end);  ya = min([-.15 yb]);  yb = max([0 yb]);  dy = (ya-yb)/50;
    set(S.ax(2),'ylim',[ya-dy yb+dy]);
    pause(1-get(S.sli,'value'));       % adjust the speed of the loop
  end;
% end function btn
