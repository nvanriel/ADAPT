% plt.m:   An alternative to plot and plotyy (version 13Mar14)
% Author:  Paul Mennen (paul@mennen.org)
%          Copyright (c) 2014, Paul Mennen
%
% examples:                 (nt = number of traces)
% ---------                 ---------------------------------------------
% plt                     : opens the workspace plotter
% plt(y)                  : same as plot(y) except cursors are provided
% plt(x,y)                : same as plot(x,y) except cursors are provided
% plt(x1,y1,x2,y2,...)    : up to 99 traces may be ploted on one axis
% plt(...,'Right',r)      : Specify a vector of trace numbers for the right hand axis
% plt(...,'DualCur',d)    : Specify a trace number for the dual cursor
% plt(...,'Title','t')    : Specify plot title
% plt(...,'Xlim',[0 8])   : Specify x-axis limits
% plt(...,'Ylim',[1 5])   : Specify y-axis limits
% plt(...,'YlimR',[0 2])  : Specify y-axis limits for the right hand axis
% plt(...,'LabelX','a')   : Specify x-axis label
% plt(...,'LabelY','b')   : Specify y-axis label
% plt(...,'LabelYR','c')  : Specify y-axis label for the right hand axis
% plt(...,'FigName','d')  : Specify figure name
% plt(...,'PltBKc',c)     : Specify plot background color (c = 1x3)
% plt(...,'FigBKc',c)     : Specify figure background color (c = 1x3)
% plt(...,'TRACEc',c)     : Trace color. (c = nt x 3)
% plt(...,'DELTAc',c)     : Specify delta cursor color (c = 1x3)
% plt(...,'xyAXc',c)      : Specify axis color (c = 1x3)
% plt(...,'xyLBLc',c)     : Specify axis label color (c = 1x3)
% plt(...,'CURSORc',c)    : Specify cursor color (c = 1x3)
% plt(...,'GRIDc',c)      : Grid color. (c = 1x3)
% plt(...,'GridStyle,s)   : Grid line style
% plt(...,'COLORdef',c)   : Use Matlab's default color scheme. (c = 0 or nx3 array)
% plt(...,'Styles',s)     : Line styles (s is a string array of nt rows)
%                           (s may also be a string of nt characters)
% plt(...,'Markers',s)    : Trace markers (s is a string array of nt rows)
% plt(...,'ENAcur',e)     : To enable cursors on all traces, e=ones(1,nt)
% plt(...,'DIStrace',d)   : To enable viewing of all traces, d=zeros(1,nt)
% plt(...,'Position',p)   : p = [x(left) y(bottom) height width] in pixels
% plt(...,'AxisPos',p)    : Modify plot axis and/or traceID box positions
% plt(...,'TraceID',t)    : Trace ID labels, t is character or cell array (t=0 to disable)
% plt(...,'TraceMK',x)    : Include line types in trace selection box with markers at x
% plt(...,'TIDcolumn',t)  : # of traces to put in the TraceID box column 2,3,...
% plt(...,'ENApre',m)     : Enable metric prefixes. m=[ENAx ENAy] (0 or 1)
% plt(...,'Xstring',s)    : Auxiliary x-cursor readout (customizable)
% plt(...,'Ystring',s)    : Auxiliary y-cursor readout (customizable)
% plt(...,'moveCB',s)     : Execute callback s when the cursor is moved
% plt(...,'axisCB',s)     : Execute callback s when the axis limits are modified
% plt(...,'TIDcback',s)   : Execute callback s when any traceID tag is clicked
% plt(...,'AxisLink',m)   : m=0/1 disables/enables right-left axis link (default=1)
% plt(...,'SubPlot',v)    : each positive element in v specifies a subplot height
% plt(...,'SubTrace',v)   : Allows complete flexibility in assigning traces to subplot axes
% plt(...,'MotionZoom',f) : An external mouse buttondown function when dragging the zoombox
% plt(...,'MotionEdit',f) : An external mouse buttondown function when dragging the edit cursor
% plt(...,'Options',s)    : s is a string containing one or more of these options:
%                           'Ticks'         disables grid lines
%                           'Menu'          enables the menu bar
%                           'Slider'        enables the x-axis cursor slider
%                           'Linesmoothing' enables Matlab's undocumented Line smoothing feature
%                           'Hide'          leaves the plt figure hidden
%                           'Xlog'/'Ylog'   specifies log x-axis / y-axis
%                           '-All'/'+All'   removes/adds all menubox items
%                           '-Help'/'+Help' removes/adds Help from menubox
%                           '-Mark'/'+Mark' removes/adds Mark from menubox
%                           '-Xlog'/'+Xlog' removes/adds X lin log toggle from menubox
%                           '-Ylog'/'+Ylog' removes/adds Y lon log toggle from menubox
%                           '-Grid'/'+Grid' removes/adds Grid from menubox
%                           '-Figmenu'/'+F' removes/adds Menu from menubox
%                           '-Zout'/'+Z'    removes/adds ZoomOut from menubox
%                           '-Rotate'/'+R'  removes/adds XY<-> from menubox
% plt(...,'HelpFile',s)   : s is a string specifying an alternate help file (left click)
% plt(...,'HelpFileR',s)  : s is a string specifying an alternate help file (right click)
% plt(...,'ColorFile',s)  : s is a string specifying an alternate color file
% plt('Link',n,...)       : Opens a plt figure linked with plt figure with handle n. All linked
%                           figures are closed when any member of the group is closed.
% plt('Fig',n,...)        : Opens plt in figure #n (Must be first in argument list)

%
% As with plot, plt returns a vector of line handles.
% The arguments may be in any order except that the y argument must immediately
% follow the x vector when plotting y vs. x.
% For example, these all do the same thing:
%   plt('Title','Fig 4.1',x,y,'Ylim',[0 8],x,y2);
%   plt(x,[y;y2],'Title','Fig 4.1','Ylim',[0 8]);  % if y is a row vector
%   plt('Title','Fig 4.1','Ylim',[0 8],x,[y y2]);  % if y is a column vector
% If y is real, then plt(y) is the same as plt(1:length(y),y).
% If y is complex, then plt(y) is the same as plt(real(y),imag(y)).
% Line styles may also specify markers. For example, this plots 8 lines that
% alternate between solid & dotted:  plt(1:50,(1:8)'*(1:50),'Style','-.-.-.-.');
% The right hand y-axis is enabled if either the YlimR or the LabelYR arguments
% are given. Only the last x,y pair specified is plotted on the right hand axis.
% 
% Note that the figure window size is adjustable using the mouse
% Up to 99 traces may be plotted.
%
% AUXILIARY plt functions ---------------------------------------------------------
% plt version            : returns plt version
% plt help               : displays plt help file (type 'help plt' for brief help)
% plt close              : closes all plt figure windows
% plt hideCur            : hides the menu box and all cursor objects
% plt('metricp',x)       : returns [MetrixPrefix Multiplier]
% plt('slider',...)      : function for creating slider pseudo objects
% plt('edit',...)        : function for creating edit text pseudo objects
% plt('pop',...)         : function for creating popup text pseudo objects
% plt('grid',...)        : function for creating grid line pseudo objects
% plt('ColorPick',...)   : function for creating ColorPick pseudo objects
% plt('cursor',...)      : cursor functions
% plt('showTrace',e)     : e = list of trace #'s to enable. All others are disabled.
% plt('rename',s)        : sets trace IDs to s{1},s{2}, ...
%
% The cursor ID is stored in the axis userdata allowing access to cursor functions.
% For example these two lines return the cursor position and sets the x-axis limits
%    Cursor_Position = plt('cursor',get(gca,'UserData'),'get','position');
%    plt('cursor',get(gca,'UserData'),'set','xlim',[x0 x1]);
% type 'plt help' for more information on the auxiliary plt functions
