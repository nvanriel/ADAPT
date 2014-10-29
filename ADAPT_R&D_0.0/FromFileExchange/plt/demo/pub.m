% pub.m ------------------------------------------------------------
%
% All the other plt examples in the demo folder use plotting formats appropriate
% for data exploration (the main design goal of plt). However plt can also use
% formats appropriate for creating plots for publication. This script demonstrates
% this by creating three different figures windows. Note that all 3 windows are
% created by calling "pltpub" which simply calls "plt" with several parameters
% optimized for creating publishable plots.

% The first window (plot 1) is a bar chart that demonstrates how to embed the
% plot data inside the script as comments. It also demonstrates the use of the
% prin function to display a table of random numbers in a text box

% The second window (plot 2 - lower left) demonstrates how to distrubute
% 15 functions among 5 subplots by using the Subtrace parameter and how
% to set the trace colors and line styles.

% The third window (plot 3 - lower right) contains two traces with error
% bars and shows how to use text objects to create specially formatted tick labels.

% Demonstates how to define a new plotting function (pltpub in this example)
% which has a different set of defaults optimized for a particular purpose.

% Uses the 'COLORdef' parameter to select a white plot background
% Uses the 'NoCursor' option to remove the cursor objects
% Uses the 'LineSmoothing' option to improve plot esthestics
% Uses the 'TraceID','' parameter to remove the TraceID box
% Demonstrates various ways of modifying the grid lines
% Shows the use of the "+ - < > ." prefixes to modify properties of
%   +    left axis
%   -    right axis
%   <    left y label
%   >    right y label
%   .    x label

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function pub()
% -----------------------------------------------------------------------------------
%                                    Plot 1
%------------------------------------------------------------------------------------
f = fopen(which(mfilename),'rt');     % read the data from the currently running script
k = 0;                                % count the number of data lines read
start = datenum('01-Jan-93');
while 1
  s = fgetl(f);                       % read next line of the script file
  if ~ischar(s)                          break;    end;
  if length(s)<18 | sum(s(1:2)=='%.')~=2 continue; end;  % process only lines starting with '%.'
  d = findstr(s,'-');    if length(d)~=2 continue; end;  % ignore lines without exactly 2 dashes
  c = findstr(s,',');    if length(c)~=1 continue; end;  % ignore lines without exactly 1 comma
  k = k + 1;
  t(k) = (datenum(s(4:c-1)) - start)/365; % time since start (in years)
  v(k) = sscanf(s(c+1:end),'%f');          % read values (in billions of dollars)
  date{k} = s(d(1)+1:c-1);                 % save only the month and year
end;
fclose(f);

pltpub(Pvbar(t,950,v),'Position',[8 570 1140 440],'AxisPos',[.5 1.15 .76 .98],...
   'Figname','Plot 1: Bar chart','Xlim',t([1 end])+[-.2 .2],'Ylim',[450 max(v)*1.01],...
   'LabelX','Years since 1-Jan-93','LabelY','Billions of dollars',...
   'LineWidth',4,'+<.FontSize',14,'<.Color',[0 0 .7]);
p = -1;
for m=1:k text(t(m),500,date(m),'rot',90); end; % create a string for each data element
uicontrol('string','print','pos',[12 6 40 20],...
          'callback','plt(''hcpy'',''init'',gcf);');  % include a print button
yt = get(gca,'ytick');  set(gca,'ytick',yt(2:end));   % remove lowest y tick mark
plt('grid',gca,'update');                             % update grid lines
g = findobj(gcf,'user','grid');  y = get(g,'y');      % get y-values of the grid lines
y(find(y==max(y))) = 0;  set(g,'y',y);                % disable vertical grid lines
r = 1e-6 * 1e20.^(rand(4,29));                        % generate random table of numbers
h1 = '  ~,  This text box containing an array of random numbers ';             % table title
h2 = 'shows how to use the prin( ) function to generate fixed width tables.';
h3 = '  ~,  ~,     A0        A1        A2        A3       ~,  4{-------   }';  % table headings
s = prin([h1 h2 h3 '29{ ~, 4{%7V   }}'],r);           % using nested numbered repeats
% s = [prin([h1 h2 h3]) prin('4{%7V   }~, ',r)];      % equivalent to above (without using nesting)
uicontrol('style','text','units','norm','pos',[.72 .04 .27 .93],'background',[.9 1 .8],...
          'fontname','Lucida Console','string',s);    % display table of numbers in a text box

% -----------------------------------------------------------------------------------
%                                    Plot 2
%------------------------------------------------------------------------------------
t = (-199:2:199)/200;
b = [-50:50 49:-1:-49];

y = [b.^2;                    b.^3;           filter(ones(1,30),1,1./(b+.5));
     cos(30*t).*abs(t.^-.3);  cos(20*t)./t;   min(20,max(-20,1./cos(30*t.^2)));
     1./(.02+t.^2);           t./(.02+t.^2);  min(15,max(-15,(cos(30*t)./t)));
     humps(t);                humps(-t);      humps(t.^2);
     sin(30*t.^3);            sin(40*t)./t;   sin(40*t).*abs(t.^-.5)];
sz = ones(size(t));
m = min(y')';   y = y - m(:,sz);  % shift functions up so that they are postive
m = max(y')';  y = .96 * y ./ m(:,sz) + .02;  % normalize all functions to one
h = pltpub(t,y,'Figname','Plot 2: Publications with subplots','Position',[8 55 800 480],...
    'SubPlot',[33 33 33 -50 50 50],'SubTrace',3*ones(1,5),'TraceC',('brkbrkbrkbrkbrk')',...
    'AxisPos',[.45 .7 1.1 1.06],'Linewidth',num2cell('222211221122111'-48),'styles','---------x-----',...
    'Ylabel',prin('5{functions %d-%d! ~, }',1,3,4,6,7,9,10,12,13,15),...
    'Xlabel',prin('2{X axis for functions %d-%d! ~, }',1,9,10,15));


% -----------------------------------------------------------------------------------
%                                    Plot 3
%------------------------------------------------------------------------------------

time = (0:36)/4;              n = length(time);
t2 = time(2:2:end);           m = length(t2);
temp  = 35 + 15*sin(time/3);  events = 10 + 25*sin(t2/3) + 20*rand(1,m);
tempL =  3 + 7*rand(1,n);     eventsL = 3 + 12*rand(1,m);
tempU =  3 + 7*rand(1,n);     eventsU = 3 + 12*rand(1,m);
t3 = 0:.05:9;                 e3 = interp1(t2,events,t3,'spline');

pltpub('Right',1:2,time,temp,Pebar(time,temp,tempL,tempU,60),...
    t3,e3,Pebar(t2,events,eventsL,eventsU,50),'LineWidth',{1,3,2,3},...
   '+Ycolor','b','-Ycolor','r','TraceC',('rrbb')',...
   'FigName','Plot 3: Activity & Temperature vs Time of day',...
   'LabelY',{'# of Events' 'Temperature (\circC)'},...
   'LabelX','Time of day (13-Feb-09)','+-<>.FontSize',14,...
   'Xlim',time([1 end])+[-.2 .2],'Ylim',{[0 100] [0 60]},...
   '+XtickLabel',' ','AxisPos',[.7 1.1 1.04 .99],...
   'Position',[825 55 670 480]);

set(gca,'Xtick',0:max(time)); % make sure a vertical grid line appears every hour
plt('grid',gca,'update');

for k=0:9
  text(k,-3.5,sprintf('%2d:00',k+12),'horiz','center','fontw','bold');
end;

function out = pltpub(varargin) % function optimized creating plots for publication
  out = plt('ColorDef',0,'TraceID',0,'Options','-All Nocursor LineSmoothing',varargin{:});

% -----------------------------------------------------------------------------------
% This is the data for the bar chart (plot 1) which was exported from excel as a csv:
%------------------------------------------------------------------------------------

%. 16-Feb-93, 1103
%. 10-Jun-93, 1206
%. 05-Nov-93, 1224
%. 31-Mar-94, 1190
%. 31-Jul-94, 1241
%. 11-Oct-94, 1256
%. 05-May-95, 1325
%. 30-Sep-95, 1431
%. 31-Dec-95, 1456
%. 30-Jun-96, 1512
%. 24-Nov-96, 1745
%. 09-May-97, 1829
%. 07-Oct-97, 2355
%. 20-Jan-98, 2192
%. 17-Jul-98, 2307
%. 27-Jan-99, 2147
%. 03-Jun-99, 2465
%. 31-Dec-99, 2468
%. 23-Apr-00, 2461
%. 31-Aug-00, 2534
%. 19-Dec-00, 2462
%. 20-May-01, 2659
%. 19-Jan-02, 2550
%. 11-Oct-02, 2216
%. 14-Apr-03, 2310
%. 18-Sep-03, 2594
%. 19-Jan-04, 2808
%. 13-Sep-04, 2805
%. 18-Jan-05, 3023
%. 11-Apr-05, 3152
%. 25-Sep-05, 3275
%. 23-Dec-05, 3373
%. 15-May-06, 3973
%. 15-Sep-06, 3800

