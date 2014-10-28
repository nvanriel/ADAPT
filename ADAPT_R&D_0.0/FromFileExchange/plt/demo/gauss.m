% gauss.m ---------------------------------------------------------
% This example script plots the results of combining uniform
% random variables.
% - Shows the advantage of setting the line data after the plt(..) call.
% - Note the use of the 'FigName' and 'TraceID' arguments.
% - Note the appearance of the greek letter in the x-axis label.
% - Uses the 'COLORdef' argument to select Matlab's default plotting
%   colors (which are typically set to use a white background for the
%   plotting area)
% - Shows how to use the 'Options' argument to enable the x-axis cursor
%   slider (which appears just below the peak and valley finder buttons).
% - Uses the 'DIStrace' argument so that gauss.m starts off with some
%   traces disabled.
% - Shows an example of the use of the 'MotionZoom' parameter. To see what
%   it does, create a zoom box by holding both mouse buttons down and draging
%   the mouse in the plot window.
% - The zoom window plot also demonstrates an easy way to copy the trace data
%   from one plot to another (in this case from the main plot to the zoom plot).

% ----- Author: ----- Paul Mennen
% ----- Email:  ----- paul@mennen.org

function gauss(a,xyLim)

mxN = 10;                       % sum up to 10 uniform distributions
traceID = prin('Gauss ~, {Sum%2d!row}',2:mxN);
if ~nargin                      % Initialize gauss window section ------------
  dis = [0 0 0 ones(1,mxN-3)];  % initially just show the first 3 traces
  h = plt(1,ones(1,mxN),'FigName','Sum of uniform distributions',...
           'TraceID',traceID,'MotionZoom','gauss','COLORdef','default',...
           'LabelX','Standard deviation (\sigma)','LabelY','',...
           'DIStrace',dis,'xlim',[-4 4],'ylim',[-.05 1.05],'Options','S-X-Y');
  sz = 100;                     % size of each uniform distribution
  u = ones(1,sz);               % uniform distribution
  y = u;                        % y will be composite distribution
  for n = 2:length(h)
    y = conv(y,u);              % convolve with next uniform distribution
    m = length(y);  mean = (m+1)/2;   sigma = sz * sqrt(n/12);
    x = ((1:m) - mean) / sigma; % change units to sigma (zero mean)
    set(h(n),'x',x,'y',y/max(y));
  end;
  set(h(1),'x',x,'y',exp(-(x.^2)/2)); % gaussian distribution
else                            % zoom box motion function ------------------
  zoomFig = 'Gauss Zoom Window'; g = gcf;  f = findobj('name',zoomFig);
  if isempty(f) % create the zoom window if it doesn't already exist
     h = getappdata(gcf,'Lhandles');    % get x/y vectors for all 10 traces into 1 cell array
     vis = get(h,'vis'); xy = [get(h,'x') get(h,'y')]';
     dis = strrep(strrep([vis{:}],'off','1'),'on','0')'-'0'; % traces to disable
     plt(xy{:},'TraceID',traceID,'LabelX','','LabelY','','Options','-All','DIStrace',dis,...
         'FigName',zoomFig,'Position',[720 45 425 525],'AxisPos',[1.5,1,.9,1,1.6]);
     f = gcf;
  end;
  ax = getappdata(f,'axis');
  xlim = sort(xyLim(1:2));              % get the limits of the zoom window
  ylim = sort(xyLim(3:4));
  if diff(xlim)*diff(ylim) > 0          % ignore the limits if xmin=xmax or ymin=ymax
    set(ax(1),'xlim',xlim,'ylim',ylim); % set the limits of the zoom axis
    plt('grid',ax);                     % update grid lines
  end;
  figure(g);                            % restore focus to main window
end;  
