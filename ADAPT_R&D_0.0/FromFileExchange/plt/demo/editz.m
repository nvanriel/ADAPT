% editz.m - A primitive filter design program.
% ---------------------------------------------------------------
% This function demonstrates the usefulness of plt's data editing
% capability. Two plots are created, one showing the poles and
% zeros of a z-plane transfer function and the other showing the
% magnitude and phase of it's frequency response. The frequency
% response plot automatically updates even while you are dragging
% a root to a new location. At first the updating in real time
% (i.e. while you are dragging) may not seem so important, but when
% you use the program its importance becomes clear. This is
% accomplished by using the 'MotionEdit' parameter (see line 125).
% My other purpose in writing this little application was to create
% a tool for engineering students to help them develop a feel for
% how the magnitude and phase response reacts to a change in the
% positions of the transfer function poles and zeros.
%
% When the program first starts, text appears in the pole/zero plot
% that tells you how you can use the mouse to move the roots of the
% transfer function. However it is easy to miss these important
% instructions since they dissappear as soon as you click on anything
% in that figure widow. (This was necessary to manage clutter).
% However you can re-enable the help text at any time by clickin on
% the yellow "editz help" tag which is centered near the left edge
% of the figure window.
%
% In the frequency plot, the x-cursor edit box shows the cursor
% location as a fraction of the sample rate. The Xstring
% parameter is used to show this as an angular measure (in degrees)
% just to the right of the x-cursor readout. Since the DualCur
% parameter is used, there are two y-cursor edit boxes. The first
% one (green) shows the magnitude response in dB and the second one
% (purple) shows the phase response in degrees. The Ystring
% parameter is used to show the magnitude response in linear form
% (in percent). Note that after the plot command, the Ystring is
% moved to the left of the plot because by default the Ystring
% appears in the same place as the dual cursor. The alternate
% location allows room for a multi-line Ystring which is generated
% compliments of prin's cell array output feature. The AxisLink
% parameter is used so that by default the mag/phase axes are
% controlled separately.
%
% In the pole/zero plot, the x and y-cursor edit boxes show the
% pole/zero locations in cartesian form. The Xstring parameter
% shows the polar form just to the right of the x-cursor readout.
%
% Normally plt's data editing is initiated when you right click on
% either the x or the y cursor readouts. However when data editing
% is being used extensively (as in this program) it is useful to
% provide an easier way to enter editing mode. In this program, this
% is done with the patch object that appears just below the traceID
% box. (The patch object is created on line 140 of this file). The
% 'Dedit' application data variable is used (see lines 130 to 132)
% to change the default editing mode from the usual default (change
% only the y coordinate) to the alternative (allow changing both the
% x and y coordinates. Also the application data variable 'EditCur'
% (see line 133) is used to change the default size of the cursors
% used for editing.
%
% Notice that while dragging a pole or a zero to a new location, the
% pole or zero remains inside the diamond shape edit cursor ... except
% that is when you get close to the x axis. At that point the root
% jumps out of the edit cursor and sticks to the x axis (for as long
% as the edit cursor remains inside the green band). Without this snap
% to behavior it would be nearly impossible to create a real root.
% Similarly, when you drag a zero (but not a pole) "close" enough to
% the unit circle, the zero will "snap to" the circle. Without this
% feature it would be difficult to create a transfer function with a
% symetric numerator polynomial.
%
% How "close" is close enough for these snap to operations? Well
% this is determined by the Tolerance slider which is in the lower
% left corner of the pole/zero plot. Notice that as you move this
% slider, the width of the green band surrounding the x-axis and the
% unit circle gets bigger. If you want to disable the snap to feature,
% simply move the tolerance slider to 0.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function editz(a)               % A primitive filter design program.
  if nargin % pole/zero edit mouse motion function -------------------------------------
    a=getappdata(gcf,'Dedit'); hact=a(3); % hact is the handle of the moving edit cursor
    h = get(hact,'user');  h = h(1);      % h is handle of the line being edited
    p = getxy(hact);                      % position of edit cursor (diamond)
    q = getxy(h);                         % position of poles or zeros being edited
    k = getappdata(gcf,'DragRoot');       % do we know which root we are dragging?
    if isempty(k)                         % here if not
      [v,k] = min(abs(q-p));              % find the root that we are dragging around
      setappdata(gcf,'DragRoot',k);       % remember this for later
    end;
    q(k) = p; setxy(h,q); % replace its value with the cursor position & update the pz plot
    plt('cursor',getappdata(gcf,'cid'),'mainCur',0); % update FrqResp & Xstring (mag/angle)
    return;
  end;
  % initialize ------------------------------------------------------------------------
  helpT = {...  % help text
   'Only the roots on or above the x axis are shown';
   '- To move a root:'; '      Click on it';
   '      Then click inside the red box under the TraceIDs';
   '      Then drag the root to the desired location';
   '      The root will snap to the x-axis if you get close';
   '      A zero will snap to the unit circle if you get close';
   '- To add a root, click on the New Zero or New Pole button';
   '- To remove a root, drag it below the x-axis';
   'Click here'; 'to allow a'; 'root to be'; 'dragged'};
  z=roots([1 4.3 8 8 4.3 1]); p=roots([1 .38 .82]);    % initial numerator/denominator polynomials
  z=z(find(imag(z)>-1e-5));  p=p(find(imag(p)>-1e-5)); % plot only upper half of unit circle
  uc = exp((0:.01:1)*pi*1j);    % uc = half unit circle (101 points)
  x = 0:.001:.5;                % frequency axis
  set(0,'units','pix');  ssz = get(0,'screensize');
  pos = [7 55 755 460];         % positions of pole/zero plot
  if ssz(4)>1180  pos2 = pos + [0 pos(4)+35 0 0];
  else            pos2 = pos([3 4]);    pos2 = [ssz([3 4]) - pos2 - pos([1 2]) pos2];
  end;
  % frequency response plot -----------------------------------------------------------
  S.fr = plt(x,x,x,x,'FigName','Frequency response','Ylim',[-100 1],'YlimR',[-400 200],...
       'TRACEid',{'Mag','Phase'},'LabelY',{'dB' 'Phase'},'AxisLink',0,'Title',' ',...
       'Xstring','sprintf("%4.2f\\circ",360*@XVAL)','LabelX','Fraction of sample rate',...
       'Ystring','prin("Mag (lin) = ~, %6.4f%%",100*min(1,10^(@YVAL/20)))',...
       'FigBKc',[0 .1 .2],'ENApre',[0 0],'Position',pos2,'Options','Slider-Y','DualCur',2);
  S.ti = get(gca,'title');
  k = findobj(gcf,'user','TraceID'); % move traceID box down to give room for H(z) text
  set(k,'pos',get(k,'pos') - [0 .06 0 0]);
  k = get(gca,'title');              % reposition axis title to give more room for H(z)
  set(k,'pos',get(k,'pos') - [.02 0 0]);  set(k,'units','norm');
  S.H = exp(pi*get(S.fr(1),'x')*2i); % used for evaluating polynomial around unit circle
  set(findobj(gcf,'tag','ystr'),'pos',[-3.4 17],'color','green'); % move Ystring
  hfig = gcf;
  % pole/zero plot ---------------------------------------------------------------------
  S.pz = plt(z,p,uc,'Xlim',[-1.1 1.1],'Ylim',[-.12,1.3],'ENAcur',[1 1 0],...
       'TRACEc',[0 1 1; 1 1 0; .5 .5 .5],'Styles','nn-','Markers','oxn','Link',gcf,...
       'LabelX','real','LabelY','imag','FIGname','Pole/Zero plot','Position',pos,...
       'TRACEid',['Zeros '; 'Poles ';'circle'],'MotionEdit','editz','Options','-X-Y',...
       'Xstring','sprintf("  (%4.3f, %4.2f\\circ)",abs(@XY),angle(@XY)*180/pi)');
  set(findobj(gcf,'style','push'),'vis','off'); % delta & peak/valley buttons not needed
  mb = findobj(gcf,'tag','MenuBox');
  set(mb,'pos',get(mb,'pos')+[0 .05 0 0]); % move menu box up (make room for Tol slider)
  a = getappdata(gcf,'Dedit');  % default edit mode for xCursor edit box right click is "Modify Up/Down"
  a(2) = 7; % use 4,5,6,7,8,9 for Insert,InsertLeftRight,InsertUpDown,Modify,ModifyLeftRight,ModifyUpDown
  setappdata(gcf,'Dedit',a);     % change it to Modify
  setappdata(gcf,'EditCur',getappdata(gcf,'EditCur')+2);  % make edit cursor larger
  uicontrol('string','New Zero','units','normal','pos',[.006 .44 .08 .05],'Callback',@newPZ);
  uicontrol('string','New Pole','units','normal','pos',[.006 .37 .08 .05],'Callback',@newPZ);
  S.tx = text([-.5*ones(9,1);-1.43*ones(4,1)],[1.1;.7;.63;.56;.49;.42;.35;.25;.15;1.01;.95;.89;.83],helpT);
  set(S.tx,'color',[.5 .5 1]);  set(S.tx(1),'color',[1 .5 .5]);
  text(-.16,.56,'editz help','units','norm','color',[0 1 0],'ButtonDownFcn',@helpTag);
  patch([.1 .1 1.1 1.1],-[5 10 10 5],[.2 0 0],'EdgeC',[.2 0 0],'clip','off',...
         'parent',findobj(gcf,'user','TraceID'),'ButtonDown','plt click EDIT 1;');
  S.pa = patch(0,0,'k');  S.pa2 = patch(0,0,'k');
  fcn = get(findobj(gcf,'user','grid'),'ButtonDown'); % needed only for Matlab ver 6 (bug with patch)
  set([S.pa S.pa2],'FaceColor',[0 .15 .15],'EdgeColor',[0 .15 .15],'ButtonDown',fcn);
  ch=get(gca,'child'); set(gca,'child',ch([3:end 1 2])); % move patches to bottom of viewing stack
  S.sl = plt('slider',[.005 .08 .13],[.025 0 .05],'Tolerance',@sliderCB,[4 .001],'%1.3f');
  setappdata(gcf,'Ss',S); % save the handle list
  plt('cursor',getappdata(gcf,'cid'),'set','moveCB',@curCB);
  curCB; helpTag; sliderCB; % update frequency response plot, show help text, set tolerance patch
% end function editz

function newPZ(a,b)  % add a new pole or zero
  S = getappdata(gcf,'Ss');  t = get(gco,'string');
  u = 1 + (t(5)=='P');       r = S.pz(u);       % u=1/2 for new zero/pole
  setxy(r,[0 getxy(r)]);  % insert new root [(0,0)] at the beginning of list
  plt('cursor',getappdata(gcf,'cid'),'set','activeLine',u,1); % move the cursor to the new root
  plt click EDIT 1;                                           % and put it in edit mode
% end function newPZ

function sliderCB()  % tolerance slider callback
  S = getappdata(gcf,'Ss');
  v = plt('slider',S.sl,'get','value');           % get tolerance value from slider
  setxy(S.pa,[-1-v -1-v 1+v 1+v]+[-v v v -v]*1j); % set patch around x axis
  uc = exp((0:.02:1)*pi*1j);                      % half unit circle
  setxy(S.pa2,[(1+v)*uc (1-v)*fliplr(uc)]);       % set patch around unit circle (outsie/inside)
% end function sliderCB

function curCB() % pz plot cursor callback
  S = getappdata(gcf,'Ss');
  set(S.tx,'visible','off');               % turn off help text
  z = getxy(S.pz(1));  p = getxy(S.pz(2)); % get zeros and poles from plot
  ytol = plt('slider',S.sl,'get','value'); % snap to tolerance
  a = getappdata(gcf,'Dedit');  a = isempty(get(a(3),'buttondown')); % a=0 when we're in edit mode
  if a  setappdata(gcf,'DragRoot',[]);  % skip this section if we are in data edit mode
        z(find(imag(z)<-ytol)) = [];    % delete any roots dragged below the x axis
        p(find(imag(p)<-ytol)) = [];
  end;
  az=find(abs(imag(z))<ytol); ap=find(abs(imag(p))<ytol); % any roots close to the x axis?
  z(az)=real(z(az));          p(ap)=real(p(ap));          % if so, snap to the x axis
  az = find(abs(1-abs(z))<ytol);           % any zeros close to the unit circle?
  z(az) = exp(angle(z(az))*1j);            % if so, snap to the unit circle
  setxy(S.pz(1),z);  setxy(S.pz(2),p);     % in case anything changed
  % update the frequency response plot ---------------------
  pn = real(poly([z conj(z(find(imag(z)>1e-5)))])); % append complex conjugates, convert to polynomial
  pd = real(poly([p conj(p(find(imag(p)>1e-5)))])); % append complex conjugates, convert to polynomial
  pv = polyval(pn,S.H) ./ polyval(pd,S.H); % evaluate polynomials around unit circle
  H = 20 * log10(abs(pv));                 % compute frequency response (magnitude)
  % H=20*log10(abs(freqz(pn,pd,2*pi*x)));  % alternate formula for the above
  PH = angle(pv)*180/pi;                   % compute frequency response (phase)
  set(S.fr(1),'y',H-max(H));               % update frequency response plot, magnitude
  set(S.fr(2),'y',PH);                     % update frequency response plot, phase
  if length(pn)+length(pd)>15 fmt ='H(z) = {%4w!,} / {%4w!,}'; else fmt ='H(z) = {%5w!  } / {%5w!  }'; end;
  set(S.ti,'string',prin(fmt,pn,pd));
  cid = getappdata(get(get(S.fr(1),'parent'),'parent'),'cid'); % get frq response cursor ID
  [xy k] = plt('cursor',cid,'get','position');                 % get frq response cursor position
  plt('cursor',cid,'mainCur',k); plt('cursor',cid,'auxCur');   % update cursor y-axis positions
  if a assignin('base','z',z);  assignin('base','p',p); % skip this if we are in data edit mode
       assignin('base','npoly',pn);  assignin('base','dpoly',pd);
  end;
% end function curCB

function helpTag(a,b) % help tag callback
  S = getappdata(gcf,'Ss');  v = get(S.tx(1),'visible');  t = {'on' 'off'};
  set(S.tx,'visible',t{1+(v(2)=='n')}); % toggle help visibility
function c = getxy(h)   % get the x and y coordinates of object h
  c = complex(get(h,'x'),get(h,'y'));
function setxy(h,c)     % set the x and y coordinates of object h
  set(h,'x',real(c),'y',imag(c));