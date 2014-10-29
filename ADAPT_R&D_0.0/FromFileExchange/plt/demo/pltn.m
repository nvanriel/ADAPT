function pltn(numlines)
% pltn.m ------------------------------------------------------------
% Demonstrates that plt can be used to plot un unlimited number of
% traces (although trace IDs can't be used with more than 99 traces)
% - pltn(1) will plot a single trace.
% - pltn(99) or pltn with no argument will plot 99 traces.
% - You can change the number of traces ploted even after pltn is already
%   running by entering a new number in the "# of lines" edit box (lower left).
%   Try entering "1000" into this edit box just to proove that it actually works!
% - The TIDcolumn parameter is used to divide the trace IDs into 2 or 3
%   columns if necessary. (Putting all 99 IDs in one column isn't practical.)
% - The 'Ystring' parameter creates a continuous readout of the cursor index.
% - The 'Xstring' parameter creates a continuous readout of the date
%   and time corresponding to the cursor X position. The edit box form is used
%   (the question mark character at the beginning of the string).
% - A callback is written for the Xstring edit box that moves the cursor to
%   the index with a corresponding time as close as possible to the entered
%   value. For example, try this:
%     1) Click on the top trace (makes it easy to see the cursor).
%     2) Enter dates into the edit box - e.g. "30 dec 2006", "3-jan-07 9:59", etc.
%     3) Verify that the cursor moves to the corresponding point

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

if ~nargin numlines = 99; end;  % plot 99 lines if numlines not specified
timeRef = '28-Dec-06 15:38:59'; % test start time
t  = (0:399)/400;  u = 1-t;
y1 = 8.6 - 1.4*exp(-6*t).*sin(70*t);
y2 = repmat([1 0 1 0 1 0]+6.4,100,1); y2 = y2(:)';
f = (0:.15:25)-12.5; f = sin(f)./f;
y2 = filter(f,sum(f),y2); y2(1:200) = [];
y3 = 2 * t .* cos(15*u.^3) + 5;
y4 = 4 - 2*exp(-1.4*t).*sin(30*t.^5);
y5 = u .* sin(20*u.^3) + 2.2;
w = ones(ceil(numlines/5),1);  wi = flipud(cumsum(w))-1;
s = 5.3*(t-.5);  v = wi * (sqrt(16-s.*s)-3)/8;
y = [y1(w,:)+v; y2(w,:)+v; y3(w,:)+v; y4(w,:)+v; y5(w,:)+v];
y = y(1:numlines,:); t = 234.5678 * (t+.08);
n3 = 0;  % will be number of traceIDs for the 2nd column
if numlines>99 TraceID = [];
else  TraceID = prin('{id %02d!row}',1:numlines);
      if numlines>48      n3 = floor(numlines/3); n3 = [n3 n3];
      elseif numlines>24  n3 = floor(numlines/2);
      end;
end;
ylim = [min(y(end,:)) max(y(1,:))] + [-.1 .1];
S.tr = plt(t,y,'Xlim',t([1 end]),'TraceID',TraceID,'TIDcolumn',n3,...
    'LabelX',[' hours past ' timeRef],'Position',[10 50 870 700],...
    'Ylim',ylim,'FigName','pltn','Xstring','?plt("datestr",@XU+@XVAL/24)',...
    'Ystring','sprintf("Sample  # %d",@IDX)','FigBKc',[0 .15 .15]);
S.cid = getappdata(gcf,'cid');
S.ref = datenum(timeRef);
set(findobj(gcf,'tag','xstr'),'User',S.ref,'Callback',{@xstrCB,S});
uicontrol('sty','edit','units','norm','pos',[.078 .018 .044 .028],...
          'fontw','bold','foregr','blue','string',prin('%d',numlines),...
          'callb','a=str2num(get(gcbo,''str'')); close(gcf); pltn(a);');
uicontrol('sty','text','units','norm','pos',[.072 .05 .057 .02],...
          'foregr','blue','string','# of lines');
% end function pltn

function xstrCB(h,arg2,S)  % xstring edit box callback
  dt = datenum(get(h,'string')) - S.ref;
  [mn k] = min(abs(get(S.tr(1),'x')-dt*24)); % k = index minimizing time error
  plt('cursor',S.cid,'mainCur',k);           % move cursor to the desired spot
%end function xstrCB