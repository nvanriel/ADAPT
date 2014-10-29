% weight.m ----------------------------------------------------------
% - The SubPlot argument is used to create an upper and lower axis.
%   The lower axis contains 4 traces showing the magnitude of 4
%   different weighting functions used in sound level meters (as
%   defined by IEC 651). The upper axis also contains 4 traces showing
%   the same 4 functions except in dB instead of the linear units used
%   for the lower axis. The middle axis shows the inverse of the linear
%   magnitude traces, which isn't particularly interesting except that
%   I wanted to demonstrate the use of three axes.
% - Normally plt only puts one trace on each subplot except for the
%   main (lower) axis. So in this case (with 12 traces) plt puts 10
%   traces on the lower axis and one on the other two. Since we really
%   want 4 and 4 and 4, the 'SubTrace' parameter is used to specify
%   exactly which traces should be on each axis. However the plt cursoring
%   functions have not been designed to handle the 'SubTrace' parameter
%   so weight.m will have to contain some of its own cursor code.
% - Note that when you cursor any trace in the lower axis, you get
%   the y-axis readout for all three axes, and the cursor in the upper
%   two axes automatically moves to the same trace and the same x position.
%   The subplot argument usually will cause plt to do this synchronization,
%   however since that only deals with a single trace for the sublots we
%   have to use the 'moveCB' cursor callback (and case 1 of the switch
%   command) to do this synchronization.
% - The traceID callback ('TIDcback') insures that the traceID box
%   controls the upper axis traces as well (case 2 of the switch)
% - Note the LineWidth argument in the plt call. This illustrates how
%   any line property may be included in the calling sequence. 


% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function weight()
  f = 1000*10.^(-2 : 2/63 : 1.33);                       % x axis for plot
  g = f.^2;
  Wc = g ./ ((g + 20.6^2) .* (g + 12200^2));             % C weight
  Wb = Wc .* sqrt(g ./ (g + 158.5^2));                   % B weight
  Wa = Wc .* g ./ sqrt((g + 107.7^2) .* (g + 737.9^2));  % A weight
  Wd = f .* sqrt( ((1037918.48-g).^2 + 1080768.16*g) ./ ...
        (((9837328-g).^2 + 11723776*g) .* (g+79919.29) .* (g+1345600)));
  [m ref] = min(abs(f-1000)); % use 1000 Hz as the reference frequency
  W = [Wa/Wa(ref); Wb/Wb(ref); Wc/Wc(ref); Wd/Wd(ref)]; % normalize to reference
  ctrace = [0 .9 0; 1 0 1; 0 1 1; 1 1 0]; % color for A/B/C/D weighting respectively
  S.lh = plt(f,[W; 1./W; 20*log10(W)],'FigName','A B C & D Weighting','EnaPre',[0 0],...
       'LineWidth',{2 2 2 2 1 1 1 1 1 1 1 1},'TIDcback',@tidCB,'SubPlot',[40 20 40],...
       'Xlim',f([1 end]),'Ylim',[-.05 1.25],'FigBKc',[0 0 .15],'PltBKc',[.07 0 0],...
       'SubTrace',[4 4 4],'TRACEid',prin('{%X weight!row}',10:13),...
       'Options','Xlog-Y','LabelX','Hz','LabelY',{'Magnitude' '1/Mag' 'dB'},...
       'Ctrace',ctrace,'Position',[30 50 900 650]);
  S.ax  = getappdata(gcf,'axis');
  S.cid = getappdata(gcf,'cid');
  plt('cursor',S.cid(2),'set','ylim',[0 4]);    % set y limits
  plt('cursor',S.cid(3),'set','ylim',[-55 15]);
  bf = get(S.lh(1:4),{'buttond'});
  set(S.lh(5:8), {'buttond'},bf);  % Three axes, each having 4 lines
  set(S.lh(9:12),{'buttond'},bf);
  plt('cursor',S.cid(1),'set','moveCB',{@curCB,S});
  curCB(S);
  set(gcf,'user',S);  % save for traceID callback

function curCB(S) % cursor callback (moveCB)
   [n h]  = plt('cursor',S.cid(1),'get','activeLine');
   [xy k] = plt('cursor',S.cid(1),'get','position');
   x = real(xy);
   n = min(4,n);
   y2 = get(S.lh(n+4),'y');  y2 = y2(k);
   y3 = get(S.lh(n+8),'y');  y3 = y3(k);
   c = get(h,'color');
   e = findobj(gcf,'style','edit');
   set(e([6 2]),'Backgr',c,{'string'},prin('1/%5w ~; %4.2fdB',y2,y3));
   fixAx(S.ax(2),x,y2,c);
   fixAx(S.ax(3),x,y3,c);
%end function curCB

function fixAx(ax,x,y,c)
  set(findobj(ax,'markersize',8),'x',x,'y',y,'color',c);  % update cursor position and color
  yl = get(ax,'ylim');  yd = diff(yl)*[-.9 .1];           % adjust ylim if cursor out of range
  if     y>yl(2) set(ax,'ylim',y+yd);          plt('grid',ax);
  elseif y<yl(1) set(ax,'ylim',y-fliplr(yd));  plt('grid',ax);
  end;
% end function fixAx

function tidCB()    % traceID callback
  S = get(gcf,'user');
  a = get(S.lh(1:4),{'vis'});
  set(S.lh(5:12),{'vis'},[a; a])
% end function tidCB
