% pltquiv.m ---------------------------------------------------------
% - The quiv function is used to create arrows for the two complex
%   vector fields (v1/v2).
%   This is somewhat similar to the two matlab commands
%   quiver(x,y,real(v1),imag(v1); quiver(x,y,real(v2),imag(v2));
% - Using the AxisPos parameter to make room for long Trace ID names
% - Using tex commands (e.g. \uparrow) inside Trace ID names
% - Reassigning menu box items. In this example, the 'LinX' button is
%   replaced by a 'Filter' button. Its button down function (which is
%   executed when you click on 'Filter') searches for the 4th trace
%   (findobj) and swaps the contents of its user data and y-axis data.
% - Adding text items to the figure. Note that the text position is
%   specified using x and y axes coordinates
% - Using NaNs (not a number) to blank out portions of a trace
% - Using the TraceID callback function (TIDcback) to perform an action
%   when you click on a trace ID. For example, when you click on the
%   last trace ID (humps+rand) this will appear in the command window:
%   "A trace named humps+rand and color [1.00 0.00 0.00] was toggled".
%   (This TraceID callback was contrived to use all the substitutions,
%   and is not particularly useful.)

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

x  = (0:.08:5)';
x4 = (0:.01:5)';
t = x/5;
y = humps(t)/20;
f = complex(x,y);

v1 = complex(exp(-2*t).*sin(20*t), t .* cos(15*(1-t).^3));
v2 = exp(-1.4*t) .* exp(30i * t.^.5)/2;
y4  = 6 + rand(size(x4)) - humps(flipud(x4/5))/20;

h = plt(f,Pquiv(f,v1),Pquiv(f,v2),x4,y4,...
    'AxisPos',[1.2 1 .97 1 1.8],'Xlim',[-.2 5.2],'Ylim',[0 6.6],'TraceID',...
    {'humps \div 20','velocity1 \uparrow','velocity2 \uparrow','humps+rand'},...
    'FigBKc',[0 0 .2],'Options','Slider-Y-M','FigName','pltquiv','TIDcback',...
    ['disp(["A trace named " get(@TID/8192,"string") " and color "' ...
    ' prin("[{%3w! }]",get(@LINE/8192,"color")) " was toggled"]);']);
set(h(1),'LineWidth',2);
y4 = filter([1 1 1]/3,1,y4); y4 = y4([3 3:end end]); % smoothed y4
set(h(4),'tag','h4','user',y4); % save smoothed y4 in trace user data
bfn = 'h=findobj("tag","h4"); set(h,"y",get(h,"user"),"user",get(h,"y"));';
LinXtag = findobj(gcf,'string','LinX');
set(LinXtag,'string','Filter','ButtonDownFcn',strrep(bfn,'"',''''));
text(3,5.6,{'Click on ''Filter''' 'in the menu box'},'color','yellow');
text(3.6,3.6,'NaN induced gap','color','yellow','fontangle','italic');
x4(380:400) = NaN;  set(h(4),'x',x4);  % create a gap in trace 4

% Note: Identical results are achieved when:
% Pquiv(f,v1),Pquiv(f,v2)
%   is replaced by:
% Pquiv([f f],[v1 v2])
