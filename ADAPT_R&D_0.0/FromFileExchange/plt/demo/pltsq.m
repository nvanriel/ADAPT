% pltsq.m -----------------------------------------------------------
% pltsq shows how a square wave can be approximated by adding up the
% first five odd harmonics of a sine wave. To make the GUI interface
% more challenging and interesting, the amplitude is continually
% varied (periodically between plus and minus 1). If you can fully
% understand this 50 line routine, you are well on your was to
% creating your own plt based GUI applications.
% -- Demonstrates how you can add additional GUI controls to the plt
%    window. Typically this is something you will want to do when
%    creating an application based on plt.
% -- 10 uicontrols are added to the figure using 'uicontrol'
%    (4 popups, 2 buttons, and 6 text labels).
% -- The uicontrol units are changed to normalized so that they
%    reposition properly when you resize the plt figure window.
% -- The cursor callback and the plt('rename') call are used to provide
%    simultaneous cursor readouts in the TraceID box for all 5 traces.
%    (Click the stop button first to make it easier to cursor, and then
%    click anywhere in the plot area to see all 5 cursor values update.)
% -- The 'AxisPos' argument makes room for the uicontrols added above
%    the plot area and to make room for the wider TraceIDs
% -- The 'Options' argument is used to turn off grid lines (initially)
%    and to remove the y-axis Log selector from the menu box.
% -- With the Erasemode popup, you can explore the effect of the
%    erasemode property on drawing speed.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function pltsq()
  S.tr = plt(0,[0 0 0 0 0],'AxisPos',[1.4 1 .94 .94 1.9],...
    'FigName','pltsq: Square wave speed test','Options','Ticks/-Ylog',...
    'Xlim',[0 4*pi],'Ylim',[-1.05,1.05],'LabelX','Cycles','LabelY','' );
  S.era = uicontrol('string',{'normal' 'background' 'xor' 'none'});
  S.pts = uicontrol('string',prin('{%d!row}',25*2.^(0:6)));
  S.spd = uicontrol('string',prin('{%d!row}',2.^(0:10)));
  S.cyc = uicontrol('string',prin('{%d!row}',2.^(0:5)));
  S.stp = uicontrol('string','Stop','User',1);
  S.go  = uicontrol('string','Start');
  S.cid = getappdata(gcf,'cid');                  % get cursor ID
  plt('cursor',S.cid,'set','moveCB',{@curCB,S});  % set cursor callback
  ui = [S.era S.pts S.spd S.cyc S.stp S.go];
  set(ui,{'Position'},{[242 498 110 18]; [457 498 60 18]; [602 498 65 18]; 
                      [ 20 200  57 20]; [ 20 355 50 22]; [ 20 385 50 22]},...
        'Units','Norm','CallBack',{@uiCB,S});
  set(ui(1:4),'Style','Popup','BackGround',[0 1 1],{'Value'},{1;3;5;1});
  set(S.stp,'CallBack','set(gcbo,''User'',0);');
  % create a label to identify each popup menu
  set([uicontrol; uicontrol; uicontrol; uicontrol],'Style','Text',...
      {'String'},{'EraseMode';'Points/cycle';'Speed';'Cycles'},...
      {'Position'},{[150 495 90 18]; [370 495 85 18];
                    [540 495 60 18]; [ 21 220 55 20]},'Units','Norm');
  curCB(S);  uiCB(0,0,S);  % start it moving
% end function pltsq

function curCB(S)                                 % cursor callback
   [xy m] = plt('cursor',S.cid,'get','position'); % get cursor index (m)
   for k=1:5 v = get(S.tr(k),'y'); y(k)=v(m); end; % get y value for each trace
   t = 'Fund %5v ~, + 3rd %5v ~, + 5th %5v ~, + 7th %5v ~, + 9th %5v';
   plt('rename',prin(t,y));
%end function curCB

function uiCB(h,arg2,S)                  % uicontrol callbacks
  Ncyc  = 2^get(S.cyc,'Value')/2;        % Number of cycles
  Pts   = 12.5*2^get(S.pts,'Value');     % Points per cycle
  Speed = 2^get(S.spd,'Value');          % Amplitude step size
  x = [0: 1/Pts : Ncyc];                 % initialize x axis values
  plt('cursor',S.cid,'set','xlim',[0 Ncyc]);
  y = zeros(5,length(x));  v = y(1,:);
  m=1;  for k=1:5 v=v+sin(2*pi*m*x)/m;  m=m+2; y(k,:)=v; end;
  emode = get(S.era,'string');
  set(S.tr,'x',x,'y',x,'EraseMode',emode{get(S.era,'Value')});
  m = 0;  set(S.stp,'User',1);
  while ishandle(S.stp) & get(S.stp,'User')   % loop until stop is clicked
    m = m+1;  a = sin(Speed*m/6000);          % update amplitude based on Speed
    for k=1:5 set(S.tr(k),'y',a*y(k,:)); end; % update trace values
    drawnow;
  end;
%end function pltsq
