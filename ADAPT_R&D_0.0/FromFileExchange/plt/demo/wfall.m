% wfall.m -----------------------------------------------------------
% - Shows one way to create a waterfall plot with hidden line removal.
% - Note how plt is called with a single trace color and no TraceID box.
% - Extensive use of the slider pseudo object to control the plotted data.
% - Figure user data is used to communicate with dx and dy callbacks.
% - Linesmoothing option is selected (which surprisingly speeds up the display).
%
% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function wfall()
  S.n  = 30;                        % number of traces
  S.sz = 256;                       % length of each trace
  cb = 'set(gcf,"user",1)';         % Delta X/Y slider callback
  yp = .91 : -.09: .2;              % slider y positions
  z = repmat(zeros(S.sz,1),1,S.n);  % define S.n traces
  S.tr = plt(z,z,'TraceC',[0 1 0],'FigName','wfall','FigBKc',[1 1 1]/7,...
        'AxisPos',[1.2 1 .98 1],'TraceID','','LabelY','',...
        'Options','Ticks Linesmooth -X -Y','Position',[9 45 900 600]);
  S.ax   = getappdata(gcf,'axis');
  S.dly  = plt('slider',[.01 yp(1) .13],[ 0 0 999],'delay (ms)','',2);
  S.frq1 = plt('slider',[.01 yp(2) .13],[.1  0 .5],'Freq start');
  S.frq2 = plt('slider',[.01 yp(3) .13],[.45 0 .5],'Freq end');
  S.delt = plt('slider',[.01 yp(4) .13],[7  0 100],'Freq delta * 1024');
  S.dist = plt('slider',[.01 yp(5) .13],[2.7 .1 4],'Distortion (10^-x)');
  S.dx   = plt('slider',[.01 yp(6) .13],[3 0 20 0 S.sz-1],'Delta X',cb,2);
  S.dy   = plt('slider',[.01 yp(7) .13],[1 0  4 0  999],'Delta Y',cb);
  S.stop = uicontrol('String','Stop','Call','set(gcbo,''User'',0);','User',1);
  S.go   = uicontrol('String','Start','CallBack',{@start,S});
  set(gcf,'user',1);                    % make sure limits are set first time
  set(S.tr,'z',zeros(1,S.sz)+NaN);      % initialze z data
  set([S.stop S.go],'Units','Norm',...
                    {'Pos'},{[.08 .95 .06 .03]; [.01 .95 .06 .03]});
  start(0,0,S);
% end function wfall;

function start(h,arg2,S)                   % start button callback
  sz2 = S.sz*2;                            % fft length
  n = S.n;  sz = S.sz;  stop = S.stop;
  x = 1:sz;  y0 = 0:sz2-1;                 % for computing new trace data
  w = .5 -.5*cos((pi/sz)*(1:sz2));         % hanning window
  f = plt('slider',S.frq1,'get');          % starting frequency
  set(stop,'User',1);
  while ishandle(stop) & get(stop,'User')  % loop until stop button clicked
    dx = plt('slider',S.dx,'get');         % horizontal steps
    dy = plt('slider',S.dy,'get');         % vertical steps
    fstart = plt('slider',S.frq1,'get');   % advance sine wave frequency
    fend   = plt('slider',S.frq2,'get');
    fdelta = plt('slider',S.delt,'get')/1024;
    dlySec = plt('slider',S.dly,'get')/1000;   % delay in seconds
    clip = 1 - 10^-plt('slider',S.dist,'get'); % add distortion by clipping
    if get(gcf,'user')                     % was a Delta X/Y slider moved?
      set(gcf,'user',0);                   % yes, modify the axis limits
      set(S.ax,'xlim',[0 sz+n*dx],'ylim',[-.3 11+n*dy]);
      for k=1:n set(S.tr(k),'x',x+k*dx); end; % set new x data
    end;
    yc = zeros(1,sz); % comparison vector for hidden line removal
    for k=1:n-1                            % draw all but the last trace
       z = get(S.tr(k+1),'z');             % get the data from the trace above
       ym = max(yc,z);                     % stay above the trace in front
       yc = ym(dx+1:end) - dy;             % slide comparison vector to the left
       yc = [yc zeros(1,sz-length(yc))];   % and zero pad to size sz
       set(S.tr(k),'y',ym+k*dy,'z',z);     % save unclipped data in z axis
    end;
    y = fft(min(max(sin(2*pi*f*y0),-clip),clip) .* w);  % compute new trace
    z = 5 + max(-5,log(abs(y(x))));        % new data comes in at the back
    set(S.tr(n),'y',max(yc,z)+n*dy,'z',z); % draw last trace
    if fend > fstart
          f = f + fdelta;  if f>fend f=fstart; end;
    else  f = f - fdelta;  if f<fend f=fstart; end;
    end;
    pause(dlySec);                         % delay the selected amount
    drawnow;
  end;  % end while ishandle
% end function start
