function plotinfo = define_figure_details(varargin)
    
    if ~isempty(varargin)
        plotinfo = varargin{1};
    else
        plotinfo = struct();
    end
    % figure size
    dx = 10;
    dy = 50;
    ss = get(0,'ScreenSize');
    xmax = ss(3)-dx-10;
    ymax = ss(4)-dy-80;
    set(0,'DefaultFigurePosition',[dx dy xmax ymax]);
    
    
    % font size
    if ~isfield(plotinfo,'FS')
        plotinfo.FS = 24; %40;
    end
    
    % line width of axes
    if ~isfield(plotinfo,'LW_axes')
        plotinfo.LW_axes = 2; %3;
    end
    
    % line width & marker size of (raw) data points
    if ~isfield(plotinfo,'LW_data')
        plotinfo.LW_data = 2;
    end
    if ~isfield(plotinfo,'MS_data')
        plotinfo.MS_data = 14;
    end
    
    % line width of spline data
    if ~isfield(plotinfo,'LW_spline')
        plotinfo.LW_spline = 3;
    end
    
    % line width of model simulations / trajectories
    if ~isfield(plotinfo,'LW_sim')
        plotinfo.LW_sim = 4;
    end
    
    
    % text properties
    set(0,'DefaultTextFontName','Myriad')
    set(0,'DefaultTextFontSize',plotinfo.FS);
    set(0,'DefaultTextInterpreter','tex');    
    
    % line and marker properties
    set(0,'DefaultLineLineWidth',plotinfo.LW_data);
    set(0,'DefaultLineMarkerSize',plotinfo.MS_data);
    
    % axes properties
    set(0,'DefaultAxesFontName','Myriad')
    set(0,'DefaultAxesFontSize',plotinfo.FS);
    set(0,'DefaultAxesLineWidth',plotinfo.LW_axes);    
end