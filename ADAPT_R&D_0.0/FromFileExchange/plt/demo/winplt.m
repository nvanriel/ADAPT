% winplt.m (ver 01Jan14) ---------------------------------------------------
%
% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org
%
% Struggling with Matlab's FFT window display tool (wintool), I found
% it cumbersome and limited. I wanted a way to quickly change window
% parameters and see the effect on the time and frequency shapes and
% the most common window measures (scalloping and processing loss,
% frequency resolution, and equivalent noise bandwidth). I couldn't
% modify wintool for my taste since most of the code was hidden (pcode).
% So I wrote winplt.m to create a more useable gui for displaying
% windows. (To start it just type winplt - with no arguments.)
%
% You can also use winplt's command line interface to return the window
% time shapes for use in your Matlab programs. See the description below
% about the command line interface. Winplt is also a great example of gui
% programing using the plt plotting tool, however if you are just getting
% started with gui programming I would recommend starting first with some
% of the shorter examples in the plt\demo folder.
%
% Thirteen of the windows are defined by Matlab functions contained in
% the signal processing toolbox. If that toolbox is not installed
% you will see a warning that the function is not defined. (A boxcar
% window is returned in that case). Seventeen of the windows are defined
% in terms of a convolution kernel. Those windows (and the user defined
% windows) will work correctly without any toolboxes installed.
%
% If you know of some FFT windows I have not included, feel free to let
% me know about them, and I will add them to the next release. Or if you
% want to keep them secret, you will find it easy to add them to winplt
% yourself. Also feel free to suggest new features. (You can always
% reach me at paul@mennen.org).
%
% winplt(-1) ---------------------------------------------------------------
%    Displays a list of all windows and their id codes.
%
% winplt(-2) ---------------------------------------------------------------
%    Returns a cell array containing all names of the defined windows.
%
% [name, kernel] = winplt(id) ----------------------------------------------
%    Returns the name of the window associated with that id number (0 to 31)
%    The second output argument (if given) will contain the convolution
%    kernel. For windows not defined by a kernel the Matlab function
%    used to compute it is returned, along with the window parameters.
%
% winplt(id,points) --------------------------------------------------------
%    The first parameter (id) refers to one of the 31 windows listed below,
%    although the last two are user defined windows and can only be used from
%    the gui interface. A column vector is returned (of length points)
%    containing the amplitude corrected window time shape. Amplitude
%    correction means that the average value is one, i.e.:
%    sum(winplt(id,points)) = points
%
% winplt(id,points,1) ------------------------------------------------------
%    Same as above except that the window is scaled using power correction.
%    This means that the average value of the square of the window is one, i.e.:
%    sum(winplt(id,points,1).^2) = points
%
% winplt(id,points,pwr,opt) ------------------------------------------------
%    id:     An index specifying one of the FFT windows
%    points: The number of points in the time window to be generated
%    pwr:    0=amplitude correction, 1=power correction (default = 0)
%    opt:    optional window parameter
%
% winplt (with no arguments) -----------------------------------------------
%   Opens a GUI to display fft window time and frequency shapes.
%
% Click on the HelpP tag (near the lower left corner of the figure) for
% instructions on zooming and panning the display, enabling traces, and
% using the cursors.
%
% Click on the HelpW tag (right below the HelpP tag) to view a help document
% giving details about the winplt user interface.

function [out1,out2] = winplt(id,points,pwr,opt)
VerString = 'Ver 16Nov13';
out1 = 0;
out2 = 0;
switch nargin
case 0,  % no arguments: Create the winplt window
  ylim = [-145,3];
  TRACEc = [0 1 0; 0 1 0; .2 .6 1; .2 .6 1; 1 .2 .2; 1 .2 .2];
  S.tr = plt(0,zeros(1,6),'FigName','winplt (FFT window shapes)',...
    'Styles','-:-:-:-:','TIDcback',@TIDbk,...
    'AxisPos',[1 1 1 .9 1 .93 1 1],'Ylim',ylim,'YlimR',3.51+ylim/40,...
    'LabelX','Bin number','Options','-Y','Right',[2 4 6],'User','--',...
    'LabelY',{'Frequency shape (dB)' 'Time shape'},'AxisLink',0,...
    'Position',[10 45 750 550],'DisTrace',[0 0 1 1 1 1],'TRACEc',TRACEc);
  ax = getappdata(gcf,'axis');
  set(get(ax(2),'ylabel'),'units','norm','pos',[1.05 .3]); % reposition right hand yLabel
  text(0,0,VerString,'Units','Norm','Position',[.97 -.08],...
           'color',[.4 .4 .4],'fontsize',8);
  % Since we don't need the LinX help tag (menu box) for this application, next we will
  % rename that tag to 'HelpW' and use it as a winplt help tag. (It opens the winplt.chm
  % help file.) We also rename the standard plt help tag (Help) to HelpP to indicate that
  % it is just for help on plotting and not for specific help about winplt.
  set(findobj(gcf,'string','LinX'),'string','HelpW','ButtonDownFcn',@helpWinP);
  set(findobj(gcf,'string','Help'),'string','HelpP'); % 
  % Next, create the window selection popup (large font), the power correction checkbox,
  % then number of bins slider, the hanning number slider (for the RifeVincent windows)
  % and the parameter slider. Note that the last two sliders have the same screen location,
  % but this is by design since only one of them will be set to visible at a time.
  S.sel = plt('pop','choices',winplt(-2),'index',2,'callbk',@winCB,...
              'location',[.08 .905 .38 1],'fontsize',18,...
	      'hide',[findobj(gcf,'type','uicontrol'); findobj(gcf,'type','line')]);
  S.cor = uicontrol('Style','CheckBox','Units','Norm','Position',[.96 .57 .03 .04],...
                    'Callback',@winCB,'BackGround',get(gcf,'Color'),'Value',1);
  S.bin = plt('slider',[.815 530 130],[10 1 60 1 500],'# of bins',  @winCB,2);
  S.han = plt('slider',[.62  530 130],[ 1 0 10 0  10], 'Hanning ^#',@winCB,2);
  S.par = plt('slider',[.62  530 130],[ 0 0  1],' ',@winCB,1,['%4w';'%6w';'%3w']);
  % Next setup the user window string and the label for the power correction checkbox
  % Note that a separate text object was used for the power correction label because
  % the label provided for a checkbox object can't be rotated.
  S.usr = plt('edit','length',0,'callbk',@winCB,'units','norm','pos',[.13 1.04],...
              'color',[0 1 1],'string','userwin(points,param)','horiz','left');
  S.lbl = text(0,0,'Power corrected','Units','Norm','Position',[1.06 .66],...
              'Color',[.7 .8 .95],'Rotation',90,'user',[1 -.5]);
  % Create the string used to display the convolution kernel for windows that are defined
  % by one. Also used to display error messages as well as a brief help string on startup.
  % A popup is used so we can use this string as a menu for modifying the kernel.
  S.ker = plt('pop','location',[-.015 .955 .16 .3],'callbk',@kerCB,'offset',[.05,-.27],'color',[1 1 1],...
    'fontsize',9,'interp','tex','enable',0,'choices',{'Move right','Move left','Longer',...
    'Shorter','Save','Revert','Write winplt.mat','Load winplt.mat','-- cancel --'},...
    'string','Click on the window name for a menu. Right click to scroll thru the choices');
  % S.txt(1) & S.txt(5) - Display scalloping loss
  % S.txt(2) & S.txt(6) - Display the 6db bandwidth
  % S.txt(3) & S.txt(7) - Display the equivalent noise bandwidth
  % S.txt(4) & S.txt(8) - Display the worst case processing loss
  for m = 1:8  S.txt(m) = text(0,0,'');  end;  % define info text for two windows
  xp = .01*ones(4,1);  yp = (.962:-.032:.85)';   % x and y positions for info text
  set(S.txt,'fontsize',8,'units','norm','color',TRACEc(1,:),...
       {'pos'},num2cell([[xp; 75*xp] [yp; yp]],2));
  set(S.txt(5:8),'color',TRACEc(3,:),'vis','off');  % text for previous window
  ax = getappdata(gcf,'axis'); axr = ax(2);         % find right hand axis
  yt = get(axr,'ytick');  set(axr,'ytick',yt(1:5)); % remove some of the y tick labels
  S.cid = getappdata(gcf,'cid'); % get the cursor id for the callbacks
  S.adj = 2000;                  % default adjustment increment (.05%)
  set(gcf,'user',S);             % save the handle list for the callbacks
  winCB;                         % plot the default window (Hanning)
case 1, [out1 out2] = winplt(id,0);  % One argument

otherwise,                           % 2,3,or 4 arguments -------------------------------
  if ~points  % if # of points = 0, just return the window name in Out1 and the amplitude
              % corrected convolution kernel in Out2
    switch id
      case -1, t = winplt(-2); % display a list of the window names and ID numbers
               out1 = prin('iD %s\n',t{:});
      case -2, out1 = {}; % create a cell array containing the window names with their ID numbers
               for k=0:99  t = winplt(k,0); if ~ischar(t) break; end;
               out1 = [out1 {sprintf('%02d: %s',k,t)}];
               end;
      case  0, out1='Boxcar';                     out2=1;
      case  1, out1='Hanning/Rife Vincent';       out2=0;
      case  2, out1='Chebyshev';                  out2={'chebwin',90,'Sidelobe level',[50 150]};
      case  3, out1='Kaiser';                     out2={'kaiser',12.26526,'Beta',[1 30]};
      case  4, out1='Gaussian';                   out2={'gausswin',4.3,'Alpha',[.1 8]};
      case  5, out1='Tukey';                      out2={'tukeywin',.5,'Taper size',[.01 1]};
      case  6, out1='Bartlett';                   out2={'bartlett'};
      case  7, out1='Modified Bartlett-Hanning';  out2={'barthannwin'};
      case  8, out1='Bohman';                     out2={'bohmanwin'};
      case  9, out1='Nuttall';                    out2={'nuttallwin'};
      case 10, out1='Parzen';                     out2={'parzenwin'};
      case 11, out1='Taylor';                     out2={'taylorwin',-50,'Sidelobe level ',[-120 -10],5};
      case 12, out1='Hamming';                    out2=[1, -.428752];
      case 13, out1='Exact Blackman';             out2=[1, -.58201156, .090007307];
      case 14, out1='Blackman';                   out2=[1, -.595238095, .095238095];
      case 15, out1='Blackman (Matlab)';          out2={'blackman','periodic'};
      case 16, out1='Blackman Harris (Matlab)';   out2={'blackmanharris'};
      case 17, out1='Blackman Harris 61dB';       out2=[1, -.54898908, .063135301];
      case 18, out1='Blackman Harris 67dB';       out2=[1, -.58780096, .093589774];
      case 19, out1='Blackman Harris 74dB';       out2=[1, -.61793520, .116766542, -.002275157];
      case 20, out1='B-Harris 92dB (min 4term)';  out2=[1, -.68054355, .196905923, -.016278746];
      case 21, out1='Potter 210';                 out2=[1, -.61129, .11129];
      case 22, out1='Potter 310';                 out2=[1, -.684988, .2027007, -.0177127];
      case 23, out1='FlatTop  (5 term)';          out2=[1,-.965, .645, -.194, .014];
      case 24, out1='FlatTop  43dB (Potter 201)'; out2=[.9990280, -.925752, .35196]; 
      case 25, out1='FlatTop  65dB (Potter 301)'; out2=[.9994484, -.955728, .539289, -.091581]; 
      case 26, out1='FlatTop  87dB (Potter 401)'; out2=[1, -.970179, .653919, -.201947, .017552];
      case 27, out1='FlatTop  98dB (Mennen 501)'; out2=[1, -.98069, .79548, -.41115, .104466 -.0080777];
      case 28, out1='FlatTop 101dB (Mennen 601)'; out2=[1 -.98927 .85809 -.56266 .24906 -.060084 4.762e-3];
      case 29, out1='FlatTop  (Matlab)';          out2={'flattopwin','periodic'};
      case 30, out1='adjust kernel';              out2={'adjustK',0,'Parameter',[-100 100],0,0};
      case 31, out1='user';                       out2={'userwin',0,'Parameter',[-100 100],0,0};
      case 32, out1=0; % indicates no more IDs
    end;
    return;
  end;  % end if ~points
  % here if number of points is non-zero: return the time domain window shape in Out1
  if nargin<3 pwr=0; end;   % use amplitude correction if not specified
  if nargin<4 opt=[]; end;  % optional window parameter
  [out1 c] = winplt(id,0);  % get convolution kernel
  if iscell(c) % Here for Matlab computed windows ----------------------------------
    if isempty(opt) & length(c)>1
      opt = c{2};    % If the optional param is missing, use the default value
    end;
    fcn = c{1};
    if exist(fcn)
      switch length(c)                             % get computed time window 
        case 1, out1 = feval(fcn,points);          %   (without option)
        case 2, out1 = feval(fcn,points,opt);      %   (with periodic option)
        case 4, out1 = feval(fcn,points,opt);      %   (with 1 parameters)
        case 5, out1 = feval(fcn,points,c{5},opt); %   (with 2 parameters)
      end;
      if pwr out1 = out1 * sqrt(points/sum(out1.^2));  % make it power corrected
      else   out1 = out1 * points/sum(out1);           % make it amplitude corrected
      end;
    else out1 = ['Function ' c{1} ' undefined (Signal Processing toolbox required)'];
    end; % end if exist(c{1})
  else % here for kernel defined windows ------------------------------------------
    if ~c(1)                       % RifeVincent windows
      if isempty(opt) opt=1; end;  % if # of HANNs not specified, assume 1
      c = RifeV(opt);
    end;
    out1 = timew(c,points);
    if pwr out1 = out1 / sqrt((sum(2*c.^2)-c(1)^2)); end;
  end; % end if iscell(c)
end;   % end switch nargin
% end function winplt

function TIDbk  % TraceID call back
  S = get(gcf,'user');
  v = get(S.tr(3:4),'vis');         % get visibilities of traces 3 and 4
  [a k] = min(cellfun('length',v)); % find shortest string ('on' is shorter than 'off')
  set(S.txt(5:8),'vis',v{k});       % enable text if either 3rd or 4th trace is visible
%end function TIDback

function winCB(i1,i2)  % callback function (for all objects with callbacks)
  S = get(gcf,'user');
  id = plt('pop',S.sel,'get','index')-1;
  [out1 c] = winplt(id,0);  % get convolution kernel
  par = 'visOFF';
  han = 'visOFF';
  ker = '';
  opt = [];
  b = plt('slider',S.bin,'get'); bins = 2*b;  % get number of bins
  if iscell(c) % Here for Matlab computed windows ----------------------------------
    if length(c)>3                            % Here if there is a window parameter
      par = 'visON';
      if length(findobj(gcf,'string',c{3}))   % if the correct slider is already there
            opt = plt('slider',S.par,'get');  % then just get the current slider value
      else  opt = c{2};               % otherwise initialize the slider to the default
            plt('slider',S.par,'set','label',c{3});
            plt('slider',S.par,'set','minmax',[c{4} -1e99 1e99]);
            plt('slider',S.par,'set','val',opt);
      end;
    end;
  else         % Here for kernel defined windows ------------------------
    if ~c(1) han = 'visON';
             opt = plt('slider',S.han,'get');  % get number of HANNs
             if (opt>b) opt=b; plt('slider',S.han,'set',opt); end;
             c = RifeV(opt);
    end;
    S.c = c;  S.n = 0;  ker = putKern(S); % save kernel and convert to string
  end;
  set(S.usr,'vis','off');  plt('pop',S.ker,'enable',0);  % not a user window
  plt('slider',S.par,'set',par);
  plt('slider',S.han,'set',han);
  plt('slider',S.han,'set','minmax',[0 b 0 b]);
  plt('cursor',S.cid,'set','xlim',[-b b]);
  sz = 2048;                    % number of points to plot for each window
  pwr = get(S.cor,'value');     % value of checkbox (power or amplitude corrected)
  switch id
    case 30,                    % for adjustable kernel
       S = get(gcf,'user');
       c = S.c;
       n = S.n;                 % coefficient to modify with param slider
       if ~n n=1; S.n=1; end;   % select first coefficient if we just switched to id 30
       delta = '';
       v = plt('slider',S.par,'get');  va = abs(v);
       plt('slider',S.par,'set','val',0);
       if  v > 99 S.adj = v;  delta = ['  \Delta=' num2str(v)];
       elseif va==2 | va==20
                  r = 1 + .5*va/(S.adj*sqrt(abs(c(n)))); % here for slider arrow or trough
                  if v<0 r=1/r; end;
                  c(n) = r * c(n);
       elseif va  if va<1e-39 v = 0; end; % here if not (< e-39 is considered to be zero)
                  c(n) = v;
       end;
       S.c = c;
       ker = [putKern(S) delta];
       plt('pop',S.ker,'enable',1);
       ts = timew(c,bins);
       t  = timew(c,sz);
       if pwr t = t * sqrt(sz/sum(t.^2));          % make it power corrected
       else   t = t * sz/sum(t);                   % make it amplitude corrected
       end;
    case 31,  % user window selection
       f = strrep(get(S.usr,'str'),'param',num2str(opt));
       try,   ts = evalUsr(f,bins);
              t  = evalUsr(f,sz);
              if pwr t = t * sqrt(sz/sum(t.^2));  % make it power corrected
              else   t = t * sz/sum(t);           % make it amplitude corrected
              end;
       catch, t = cellstr(lasterr);                   % get error string
              t = char(t(find(cellfun('length',t)))); % remove blank lines
       end;
       set(S.usr,'vis','on');
    otherwise, t  = winplt(id,sz,pwr,opt);   % t = time window
               ts = winplt(id,bins,pwr,opt); % ts = short time window
  end;  % end switch id
  if ischar(t)
     ker = t;  t = ones(sz,1);  ts = zeros(bins,1);  % winplt returned an error message
  end;
  set(S.ker,'string',ker);
  sz2 = sz/2;  binres = bins/sz;
  h = 20*log10(eps+abs(fft([ts; zeros(sz-bins,1)]))); % freq shape
  h = h-h(1);                 % normalize to bin 0
  x = binres*(-sz2:sz2-1)';
  if gcbo==S.cor set(S.tr(2),'x',x,'y',t); return; end; % change in power factor correction
  y = get(S.tr(1:4),'y');     %          previous frequency trace
                              %          previous time trace
                              % previous previous frequency trace
                              % previous previous time trace
  y = [{[h(sz2+1:sz); h(1:sz2)]; t}; y]; % prepend current frequency & time traces (rotate h)
  i = int2str(id); u = [{['Freq' i]; ['Time' i]}; get(S.tr(1:4),'user')];
  set(S.tr(1:6),'x',x,{'y'},y,{'user'},u);
  for r6=1:sz2 if h(r6)<-6 break; end; end; % look for 6dB bandwidth
  h = h(1:1+round(.5/binres));  sloss = max(h)-min(h);
  enbw = sz*sum(t.^2)/(sum(t)^2);  ploss = sloss + 10*log10(enbw);
  if sloss < .1 sloss = sloss*1000; su = ' mdB'; else su = ' dB'; end;
  plt('rename',u); % set the trace IDs to indicate the correct window ID numbers
  s = {'scallop loss' '6dB bandwidth' 'equiv noise BW' 'worst case PL'};
  set(S.txt,{'string'},...
    [prin('%s = %6w%s ~; %s = %4w bins ~; %s = %4w bins ~; %s = %4w dB',...
         s{1},sloss,su,s{2},2*(r6-1)*binres,s{3},enbw,s{4},ploss);
     get(S.txt(1:4),{'string'})]);  % move current window info text to previous
  set(gcf,'user',S);
%end function winCB

function c = RifeV(n) % compute the kernel for the RifeVincent windows
  warning off;                           % ingore inexact nchoosek
  c = zeros(1,n+1);
  for k=0:n
    c(k+1) = (-1)^k * nchoosek(2*n,n-k); % kernel is row 2n Pascal's triangle
  end;
  c = c/c(1);                            % normalized result
%end function RifeV

function out = timew(c,sz)  % compute the length sz time window from kernel c
  out =  sz * real(ifft([c zeros(1,sz-2*length(c)+1) fliplr(c(2:end))]))';
  % x = (0:sz-1)'/sz;       % alternative version without ifft
  % out = 0*x + c(1);
  % for k = 2:length(c)
  %   out = out + 2*c(k)*cos(2*pi*(k-1)*x);
  % end;
% end function timew

function kerCB
  S = get(gcf,'user');
  l = length(S.c);  c = S.c;
  f = [which('winplt') 'at'];
  switch get(S.ker,'string')
    case 'Move right',       S.n = S.n+1; if S.n>l S.n=1; end;
    case 'Move left',        S.n = S.n-1; if S.n<1 S.n=l; end;
    case 'Longer',           c = [c -c(l)];
    case 'Shorter',          if l>1 c(l) = [];   S.n = min(S.n,l-1); end;
    case 'Save',             set(S.lbl,'user',c);
    case 'Revert',           c = get(S.lbl,'user');
    case 'Write winplt.mat', save(f,'c');
    case 'Load winplt.mat',  load(f);
  end; % end switch
  set(S.ker,'string',putKern(S));
  if ~isequal(c,S.c)  S.c = c;
                      if S.n > length(c)  S.n = 1;  end;
  end;
  set(gcf,'user',S);
  winCB;
%end function kerCB

function t = putKern(S)
  n = S.n;
  c = S.c;
  t = prin('   {%7w   }<--kernel',c);
  if n % bold face & put parenthesis around the nth coefficient
    p = findstr('   ',t); q = p(n+1); p = p(n);
    t = [t(1:p) ' ({\bf' t(p+1:q) '}) ' t(q+1:end)];
  end;
%end function putKern

function a = evalUsr(f,pts) % evaluate function f to get column vector of length pts
  a = eval(strrep(f,'points',int2str(pts)));
  a = a(:);
  n = length(a);
  if     n<pts a = [a; zeros(pts-n,1)];  % zero pad if too short
  elseif n>pts a = a(1:pts);             % truncate if too long
  end;
%end function evalUsr

function helpWinP(in1,in2)
  f = which('winplt.m');  f(end) = [];       % remove extension
  chm = [f 'chm'];                           % chm document file name
  if ispc & exist(chm) dos(['hh ' f 'chm']); % open .chm or .pdf
  else                 open([f 'pdf']); end;
%end function helpWinP
