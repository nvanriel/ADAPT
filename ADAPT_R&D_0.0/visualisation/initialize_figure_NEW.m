function m = initialize_figure_NEW(m)
    m = define_figure_details(m);
    
    % -- define default values for undefined options
    if ~isfield(m.plotinfo,'save')          %save figures
        m.plotinfo.save = 0;
    end
    if ~isfield(m.plotinfo,'figure_style')  %plot style
        if m.plotinfo.save
            m.plotinfo.figure_style = 'fig';
        else
            m.plotinfo.figure_style = 'subplot';
        end
    end
    if ~isfield(m.plotinfo,'color_coding')  %color coding
        m.plotinfo.color_coding = 'density';
    end
    if ~isfield(m.plotinfo,'save_dir')      %save directory
        if isfield(m,'phenotype')
            m.plotinfo.save_dir = [pwd '\results (' m.phenotype ')\Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '\'];
        else
            m.plotinfo.save_dir = [pwd '\results\Niter=' num2str(m.Niter) ', Ndt=' num2str(m.Ndt) '\'];
        end
    end
    m.plotinfo.save_dir = [m.plotinfo.save_dir '\'];
    if ~exist(m.plotinfo.save_dir,'dir') && m.plotinfo.save
        mkdir(m.plotinfo.save_dir)
    end
    
    
    % -- define output name of figure(s)
    switch m.plotinfo.type
        case {'state' 'flux' 'parameter' 'observable'}
            if isfield(m,'phenotype')
                filename_fig = [m.plotinfo.type ' trajectories (' m.phenotype ')'];
            else
                filename_fig = [m.plotinfo.type ' trajectories'];
            end
        case {'raw data' 'spline data' 'sampled data' 'spline+sampled data'}
            if isfield(m,'phenotype')
                filename_fig = [m.plotinfo.type ' (' m.phenotype ')'];
            else
                filename_fig = m.plotinfo.type;
            end
        case 'custom'
            if isfield(m,'phenotype')
                filename_fig = ['custom model-data pairs (' m.phenotype ')'];
            else
                filename_fig = 'custom model-data pairs';
            end
    end

    
    % -- define number of items that will be plotted
    switch m.plotinfo.type
        case {'state' 'flux' 'parameter' 'observable'}
            m.plotinfo.fieldname = get_fieldname(m.plotinfo.type);
            m.plotinfo.Nitems = length(m.info.(m.plotinfo.fieldname));        
            for ind_item = 1:m.plotinfo.Nitems
                m.plotinfo.item_names{ind_item} = get_info_mc(m.plotinfo.type,ind_item,m);
            end
        case {'raw data' 'spline data' 'sampled data' 'spline+sampled data'}
            m.plotinfo.item_names = fieldnames(R(1).raw_data);
            m.plotinfo.Nitems = length(m.plotinfo.item_names);
        case 'custom'
            m.plotinfo.Nitems = length(m.plotinfo.custom.mc);
    end
    

    % -- initialize figure windows and axes
    switch m.plotinfo.figure_style
        case 'subplot'
            m.plotinfo.FS = 18;
            m.plotinfo.LW_axes = 2;
            m.plotinfo.LW_data = 3;
            m.plotinfo.MS_data = 16;
            m.plotinfo.LW_sim = 4;
            m = define_figure_details(m);
            
            if ~isfield(m.plotinfo,'Nrows')
                m.plotinfo.Nr = ceil(sqrt(m.plotinfo.Nitems));
            else
                m.plotinfo.Nr = m.plotinfo.Nrows;
            end
            if ~isfield(m.plotinfo,'Ncolumns')
                m.plotinfo.Nc = ceil(m.plotinfo.Nitems/m.plotinfo.Nr);
            else
                m.plotinfo.Nc = m.plotinfo.Ncolumns;
            end
            
            m.plotinfo.filename_fig{1} = filename_fig;
            m.plotinfo.f(1) = figure('Name',m.plotinfo.filename_fig{1});
            for ind_item = 1:m.plotinfo.Nitems
                m.plotinfo.ax(ind_item) = subplot(m.plotinfo.Nr,m.plotinfo.Nc,ind_item); hold on
            end

        case 'fig'
            m.plotinfo.FS = 40;
            m.plotinfo.LW_axes = 3;
            m.plotinfo.LW_data = 4;
            m.plotinfo.MS_data = 26;
            m.plotinfo.LW_sim = 6;
            m = define_figure_details(m);
            
            for ind_item = 1:m.plotinfo.Nitems
                if isfield(m.plotinfo,'fieldname')
                    item_name  = m.info.(m.plotinfo.fieldname){ind_item}{1};
                else
                    all_names = fieldnames(R(1).raw_data);
                    item_name = all_names{ind_item};
                end
                m.plotinfo.filename_fig{ind_item} = [filename_fig ' [' item_name ']'];
                m.plotinfo.f(ind_item) = figure('Name',m.plotinfo.filename_fig{ind_item});
                m.plotinfo.ax(ind_item) = gca; hold on
            end
            
        case 'splitfig'
            if ~isfield(m.plotinfo,'Nrows')
                m.plotinfo.Nr = 4;
            else
                m.plotinfo.Nr = m.plotinfo.Nrows;
            end
            if ~isfield(m.plotinfo,'Ncolumns')
                m.plotinfo.Nc = 3;
            else
                m.plotinfo.Nc = m.plotinfo.Ncolumns;
            end

            for ind_item = 1:m.plotinfo.Nitems
                i_fig = ceil( ind_item / ( m.plotinfo.Nrows * m.plotinfo.Ncolumns ));
                i_subpl = ind_item - (i_fig-1) * ( m.plotinfo.Nrows * m.plotinfo.Ncolumns );

                if i_subpl == 1
                    m.plotinfo.filename_fig{i_fig} = [filename_fig ' [' num2str(i_fig) ']'];
                    m.plotinfo.f(i_fig) = figure('Name',m.plotinfo.filename_fig{i_fig});
                end
                m.plotinfo.ax(ind_item) = subplot(m.plotinfo.Nr,m.plotinfo.Nc,i_subpl);hold on
            end
    end
end