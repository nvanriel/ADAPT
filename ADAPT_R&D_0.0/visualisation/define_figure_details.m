function m = define_figure_details(varargin)
    
    if ~isempty(varargin)
        m = varargin{1};
    else
        m.plotinfo = struct();
    end
    % figure size
    dx = 10;
    dy = 50;
    ss = get(0,'ScreenSize');
    xmax = ss(3)-dx-10;
    ymax = ss(4)-dy-80;
    if isfield(m.plotinfo,'figure_size')
        if strcmp(m.plotinfo.figure_size,'fullscreen')
            set(0,'DefaultFigurePosition',[dx dy xmax ymax]);
        else
            i = strfind(m.plotinfo.figure_size,':');
            factor_x = str2double(m.plotinfo.figure_size(1:i-1));
            factor_y = str2double(m.plotinfo.figure_size(i+1:end));
            f = min([xmax/factor_x ymax/factor_y]);           
            set(0,'DefaultFigurePosition',[dx dy factor_x*f factor_y*f]);
        end
    else
        set(0,'DefaultFigurePosition',[dx dy xmax ymax]);
%         set(0,'DefaultFigurePosition',[dx dy 560 420]);
    end
    
    
    % font size
    if ~isfield(m.plotinfo,'FS')
        m.plotinfo.FS = 24; %40;
    end
    
    % line width of axes
    if ~isfield(m.plotinfo,'LW_axes')
        m.plotinfo.LW_axes = 2; %3;
    end
    
    % line width & marker size of (raw) data points
    if ~isfield(m.plotinfo,'LW_data')
        m.plotinfo.LW_data = 2;
    end
    if ~isfield(m.plotinfo,'MS_data')
        m.plotinfo.MS_data = 14;
    end
    
    % line width of spline data
    if ~isfield(m.plotinfo,'LW_spline')
        m.plotinfo.LW_spline = 3;
    end
    
    % line width of model simulations / trajectories
    if ~isfield(m.plotinfo,'LW_sim')
        m.plotinfo.LW_sim = 4;
    end
    
    
    % text properties
    set(0,'DefaultTextFontName','Myriad')
    set(0,'DefaultTextFontSize',m.plotinfo.FS);
    set(0,'DefaultTextInterpreter','tex');    
    
    % line and marker properties
    set(0,'DefaultLineLineWidth',m.plotinfo.LW_data);
    set(0,'DefaultLineMarkerSize',m.plotinfo.MS_data);
    
    % axes properties
    set(0,'DefaultAxesFontName','Myriad')
    set(0,'DefaultAxesFontSize',m.plotinfo.FS);
    set(0,'DefaultAxesLineWidth',m.plotinfo.LW_axes);    
end