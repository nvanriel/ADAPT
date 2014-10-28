% demoplt.m
% This program does not to any plotting itself, however it calls one
% of the 22 sample programes in the plt/demo folder when you click on
% the button labled with the program name. The best way to run it the
% first time is to click on the "All Demos" button which will cause
% demoplt to run all 22 sample programs in sequence. All you have to
% do is click on the orange "click to continue" button when you are
% ready to look at the next program in the list. By viewing the plots
% created by all these demos you will quickly get a overview of the
% types of plots that are possible using plt and may give you a good
% idea of how you can use plt for creating your own application.
%
% As each demo is run, you may peruse the code for the demo program
% currently being run in the demoplt list box. Use the list box
% scroll bars to view any portion of the code of interest. If the text
% is to big or small for comfort, adjust the fontsize using the
% fontsize popup menu in the lower right corner of the demoplt figure.
% This fontsize is saved (in demoplt.mat) along with the current
% figure colors and screen location so that the figure will look the
% same the next time demoplt is started.
%
% In addition to its main role as a demo program launcher, demoplt
% also demonstrates the use of one of plt's pseudo objects, namely
% the ColorPick window. (Note: A pseudo object is a collection of
% more primitive Matlab objects, assembled together to perform a
% common objective.) The ColorPick pseudo object is useful whenever
% the programmer wants to allow the user to have control over the
% the color of one of the graphic elements. In demoplt there are 3
% such elements: The text color, the text background color, and the
% figure background color. The ColorPick window is activated when
% you left or right click on any of the 3 text labels near the bottom
% of the figure, or any of the uicontrol objects adjacent to these
% labels. (Only a right click on the figure background edit box will
% bring up a ColorPick window). After the ColorPick window appears
% you can use the sliders or the color patches to change the color
% of the respective graphic element. For more details, see the
% "Pseudo objects" section in the help file.
%
% An optional feature of the ColorPick object is the color change
% callback function (a function to be called whenever a new color is
% selected). This feature is demonstrated here by assigning the color
% change callback to "demoplt(0)". Note that line 98 of this program
% can be deleted to remove this callback. The callback function is used
% to "animate" the figure by momentarily hiding the buttons. This
% particular animation is certainly not useful, but is there merely to
% demonstrate how to use the callback.
%
% Although it's unrelated to plt, demoplt also demonstrates the use of
% the close request function, which in this example is assigned to
% demoplt(1) and is used to save the currently selected colors and screen
% position to a setup file.

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function demoplt(in1)
  fg = findobj('name','demoplt');
  cfile = [which(mfilename) 'at'];  % use demoplt.mat to save figure colors
  if nargin
    bx = findobj(fg,'style','listbox');
    if in1  % here for close request function
      close(findobj('name','Color Pick'));  % close any open ColorPick windows
      fbk = get(fg,'color');  lbk = get(bx,'backgr');  lfg = get(bx,'foregr');
      fpos = get(fg,'pos');   fsz = get(bx,'fontsize');
      save(cfile,'fbk','lbk','lfg','fpos','fsz','-v4'); % save the .mat setup
      closereq;                             % close the demoplt figure
    else    % here to do the color callback function (listbox animation)
      if length(get(bx,'tag')) return; end;  % prevent callback recursion
      set(bx,'tag','0'); fs = get(bx,'fontsize');  k = fs+1;
      while k~=fs % rotate font size until we are back where we started
        k=k+1; set(bx,'fontsize',k); pause(.01); if k>28 k=1; end;
      end;
      set(bx,'tag','');  % re-enable the animation callback
    end;
    return;
  end;
  % come here if demoplt is called without arguments
  if length(fg) disp('demoplt is already running'); return; end;
  if exist(cfile) load(cfile);      % get setup infromation from .mat if it exists
  else            fbk = [0 .3 .3];  % Otherwise:  figure background color
                  lbk = [0  0  0];  %            listbox background color
                  lfg = [1  1  0];  %            listbox foreground color
                  fpos = [];        %            use default figure position
                  fsz = 9;          %            default listbox fontsize
  end;
  set(0,'units','pixels'); ssz = get(0,'screensize');  % get screen size in pixels
  w = ssz(3);
  fg = figure('name','demoplt','menu','none','number','off','double','off',...
              'pos',[w-588 50 583 420],'color',fbk,'closereq','demoplt(1)');
  bx = uicontrol('style','listbox',...  % create the listbox for viewing the demo code
                 'pos',[7 33 570 294],'string',rdfunc('demoplt'),...
                 'fontname','Lucida Console','foreground',lfg,'background',lbk);
  fcn = {'plt5'    'plt50'    'pltn'      'pltvbar' 'pltquiv' 'gauss'   ...
         'tasplt'  'trigplt'  'subplt'    'subplt8' 'winplt'  'editz'   ...
         'weight'  'curves C' 'pub'       'pltvar'  'pltsq'   'movbar(1)' ...
         'dice(0)' 'bounce'   'circles12' 'wfall'};
  x = 8;  y = 392;     % starting location for the first demo program button
  for k=1:length(fcn)  % create all 22 buttons
     u = uicontrol('Pos',[x y 65 22],'string',fcn{k},'callback',{@OneDemo,fcn{k}});
     x = x+72;  if x>530 x=8; y=y-30; end;
  end;
  uicontrol('Pos',[x y 136 22],'user',0,'BackG',fliplr(get(u,'BackG')),...
            'string','All Demos','callback',{@AllDemos,fcn});
  set(findobj(fg,'type','uicontrol'),'units','norm','fontsize',10);
  set(bx,'fontsize',fsz);
  % set(bx,'tag','0');        % disable color callback animation
  axes('pos',[1 2 6 1]/10,'units','norm');
  cb = 'plt ColorPick demoplt(0);';
  u = [text(.04,-1.6,'text color:') ...
       text(.46,-1.6,'text background:') ...
       text(.92,-1.6,'figure background:')];
  a = [uicontrol('pos',[ 75 11 40 12],'backgr',lfg) ...
       uicontrol('pos',[222 11 40 12],'backgr',lbk) ...
       uicontrol('pos',[384 9 68 17],'string',prin('{%3w!  }',fbk),...
                 'sty','edit','fontW','bold','callback',cb) ...
       uicontrol('pos',[485 6 88 22],'string',prin('{fontsize: %d!row}',4:18),...
                 'sty','popup','value',fsz-3,'fontsize',9,...
                 'callback','set(findobj(gcf,''sty'',''l''),''fontsize'',3+get(gcbo,''value''));')];
  set(a(1:2),'sty','frame','enable','inactive');
  set([u a],'units','norm','buttondown',cb);
  set(u,'color','white','horiz','right');
  q = {{'backgr',a(1),'foregr',bx,'text color'};
       {'backgr',a(2),'backgr',bx,'text background'};
       {'string',a(3),'color', fg,'figure background'}};
  setappdata(a(1),'m',q{1}); setappdata(a(2),'m',q{2}); setappdata(a(3),'m',q{3});
  setappdata(u(1),'m',q{1}); setappdata(u(2),'m',q{2}); setappdata(u(3),'m',q{3});
  if isempty(fpos) & w>1030
    fpos = [w-690 50 680 550];  % use a bigger figure for large screen sizes
  end;
  if length(fpos) set(fg,'pos',fpos); end;
  set(fg,'user',sum(get(fg,'pos')));
%end function demoplt

function s=rdfunc(func) % returns a cell array of strings from a program file
  f = findstr(func,' ');
  if length(f) func = func(1:f-1); end;
  f = fopen(which(func));  s = {};
  while 1  ln = fgetl(f);
           if ~ischar(ln), break, end
           s = [s; {ln}];
  end
  fclose(f);
%end function rdfunc

function OneDemo(h,arg2,func)
  a = findobj('type','figure');
  for k=1:length(a) % close all plt figures
    if ishandle(a(k)) & isappdata(a(k),'cid') close(a(k)); end;
  end;
  set(findobj(gcf,'style','push'),'fontw','normal');
  set(findobj(gcf,'string',func),'fontw','bold');
  set(findobj(gcf,'style','listbox'),'val',1,'string',rdfunc(func));
  if strcmp(func,'pltvar') evalin('base',func);
  else                     eval([func ';']);
  end;
  a = get(0,'child');                % list of all the figure windows
  b = findobj(a,'name','demoplt');   % find demoplt in the list
  set(0,'child',[b; a(find(a~=b))]); % force demoplt window on-top
%end function OneDemo 

function AllDemos(h,arg2,fcn)
  nf = length(fcn);
  n = get(h,'user') + 1;  % function to start
  if n>nf
    set(h,'user',0,'string','All Demos');
    close(findobj('name','wfall'));
    set(findobj(gcf,'style','push'),'fontsize',8,'fontw','normal');
    set(findobj(gcf,'style','listbox'),'string',{'' '' '   --- ALL DEMOS COMPLETED ---'});
  else set(h,'user',n,'string','click to continue');
       OneDemo(0,0,fcn{n});
  end;
%end function AllDemos
