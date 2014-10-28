% trigplt.m ------------------------------------------------------------
%
% This example demonstrates the use of the slider pseudo object as
% well as showing how to use the TraceMK parameter to show the line
% characteristics in the TraceID box. Although it can be done using
% plt parameters, this example also shows how to modify other
% characteristics of the TraceID box such as its location, colors,
% and fonts.
%
% Text objects are used to display help information at the top of the
% plot window. This help text dissappears when any parameter is changed
% but can be re-enabled by clicking on the help button.

%
% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org
%
function trigplt
  S.tr = plt(0,zeros(1,6),'FigName','trigplt: y = A sin(Bx + C) + D',...
          'Right',1:2,'AxisPos',[1 1 1 .83 1 .8 1.3 1],'Options','-X-Y',...
          'FigBKc',[0 .25 .3],'Xlim',[0 2*pi],'Ylim',{[-8 8] [-1.5 1.5]},...
          'TIDcback',@sliderCB,'DisTrace',[0 0 0 1 1 1],'Position',[10 45 780 530],...
          'TraceID',['sin';'cos';'tan';'csc';'sec';'cot'],'-Ycolor',[1 .3 .3],...
          'LabelX','radians','Styles','---:::','GRIDc',[1 1 -1]/4,'GRIDstyle',':',...
          'TraceMK',.5,'Markers',{'none' 'none' 'o' 'none' 'none' 'none'},...
          'Linewidth',{1 3 1 1 1 1},'LabelY',{'tan / csc / sec / cot' 'sin / cos'});
  line([-99 99],[0 0],'color',[1 .3 .3],'linestyle','--'); % make x-axis more obvious
  S.tx = text(0,0,'','fontsize',14,'color','yellow','units','norm','pos',[.35 1.04]);
  p = [.04 .955 .2];  dp = [.24 0 0];
  S.sl = [plt('slider',p+0*dp,[1   0  1],'--- A ---',@sliderCB,[4 .01]);
          plt('slider',p+1*dp,[1   0 20],'--- B ---',@sliderCB,[4  .2]);
          plt('slider',p+2*dp,[0  -4  4],'--- C ---',@sliderCB,[4  .1]);
          plt('slider',p+3*dp,[0 -.5 .5],'--- D ---',@sliderCB,[4 .01],...
	      ['%3w';'%4w';'%3w'])];
  S.hlp = text(1.55,7.0,...
  {'Use the sliders to change the A,B,C,D parameters';
   '     - Note that sin/cos use the right axis scale';
   '     - The remaining functions use the left axis';},'color',[1 .7 .7]);
  uicontrol('str','help', 'pos',[10 260 55 20],'CallBack',{@helpBTN,S.hlp});
  uicontrol('str','clipboard','pos',[10 230 55 20],...
            'CallBack',sprintf('print -f%d -dbitmap -noui',gcf));
  set(gcf,'user',S);
  sliderCB;            % initialize the plot
  helpBTN(0,0,S.hlp);  % enable help text
  tid = findobj(gcf,'user','TraceID');
  set(tid,'pos',[.01 .1 .09 .21]); % swap positions of the menubox & the traceID box
  set(findobj(gcf,'tag','MenuBox'),'pos',[.01 .62 .06 .22]);
  rhb = findobj(tid,'xdata',[0 .95]); % find the right hand axis identifying patches
  set(rhb,'color',[.2 0 0]); % change them to dim red (or use 'vis','off' to remove them)
  tx = findobj(tid,'type','text');    % find all the text objects in the traceID box
  set(tx,'fontname','Courier New','fontsize',11);   % change the font and size
% end function trigplt

function helpBTN(h,arg2,t)  % toggle help visibility
   v = get(t(1),'visible');
   if v(2)=='n' v='off'; else v='on'; end;
   set(t,'visible',v);
%end function helpBTN

function sliderCB()  % Update the plot based on current slider values
  S = get(gcf,'user');
  set(S.hlp,'vis','off');
  A = plt('slider',S.sl(1),'get');   B = plt('slider',S.sl(2),'get');
  C = plt('slider',S.sl(3),'get');   D = plt('slider',S.sl(4),'get');
  v = findobj(gcf,'fontw','bold'); % trace names of all enabled traces
  s = sprintf('%.2f %s(%.2fx + %.2f) + %.2f',A,get(v(end),'str'),B,C,D);
  set(S.tx,'string',strrep(s,'.00',''));
  xx = pi*[0:.02:2];  x = B*xx+C+1e-12;
  f = A*[sin(x); cos(x); tan(x); csc(x); sec(x); cot(x)] + D;
  f(find(abs(f)>10)) = NaN;
  set(S.tr,'x',xx,{'y'},{f(1,:); f(2,:); f(3,:); f(4,:); f(5,:); f(6,:)})
%end function sliderCB
