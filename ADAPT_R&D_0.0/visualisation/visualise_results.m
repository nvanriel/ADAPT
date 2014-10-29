function visualise_results(R,m,plottypes)


    % -- plot all content
    if ~iscell(plottypes)
        plottypes = {plottypes};
    end

    for i = 1:length(plottypes)
        m.plotinfo.type = plottypes{i};

        m = initialize_figure(m);
        
        for i_item = 1:m.plotinfo.Nitems
%             fprintf('%i', m.plotinfo.Nitems)
            h.raw_d(i_item) = include_raw_data(R,m,i_item);

            switch m.plotinfo.type
                case {'state' 'flux' 'parameter' 'observable'}
                    h.sim = include_model_sim(R,m,i_item);
                case 'spline data'
                    h.spl_d = include_spline_data(R,m,i_item);
                case 'sampled data'
                    include_sampled_data(R,m,i_item);
                case 'spline+sampled data'
                    h.spl_d = include_spline_data(R,m,i_item);
                    include_sampled_data(R,m,i_item);
            end

            annotate_graph(R,m,h,i_item)
        end

        % -- save figure(s)
        save_figure(m)
    end


% -------------------------------------------------------------------------------------------------------------------------
function [h1,h2] = include_raw_data(R,m,ind_item)
    item_name = m.plotinfo.item_names{ind_item};

    if m.Niter > 1 && isfield(R(2),'raw_data') && ~isempty(R(2).raw_data)
        i_max = m.Niter;
        clist = colormap_model_sim(R,m);
    else
        i_max = 1;
        clist = [0 0 0]; %black
    end
    for i_it = 1:i_max
        if isfield(R(i_it).raw_data,item_name)
            t_data = R(i_it).raw_data.(item_name).t;
            m_data = R(i_it).raw_data.(item_name).m;

            if isfield(R(i_it).raw_data.(item_name),'sd')
                sd_raw = R(i_it).raw_data.(item_name).sd;
                h1 = errorbar(m.plotinfo.ax(ind_item),t_data,m_data,sd_raw,'x',...
                        'Color',clist(i_it,:),'LineWidth',m.plotinfo.LW_data,'MarkerSize',m.plotinfo.MS_data);
            else
                h1 = plot(m.plotinfo.ax(ind_item),t_data,m_data,'x',...
                        'Color',clist(i_it,:),'LineWidth',m.plotinfo.LW_data,'MarkerSize',m.plotinfo.MS_data);
            end
            
            if isfield(m.plotinfo,'individual_datapoints') && m.plotinfo.individual_datapoints
                N = length(R(i_it).raw_data.(item_name).d(:,1));
                clist_id = colormap(hsv(N));
                h2 = [];
                for i_id = 1:N
                    t = R(i_it).raw_data.(item_name).t;
                    d = R(i_it).raw_data.(item_name).d(i_id,:);

                    h2 = [h2; plot(m.plotinfo.ax(ind_item),t,d,'.-',...
                        'Color',clist_id(i_id,:),'LineWidth',1,'MarkerSize',m.plotinfo.MS_data*1.5)];
                end
            end
        else
            h1 = 0;
            h2 = 0;
        end
    end
    
end
% -------------------------------------------------------------------------------------------------------------------------
function h = include_spline_data(R,m,ind_item)
    item_name = m.plotinfo.item_names{ind_item};
    [clist,ind] = colormap_data_splines(R,m); 
    
    if isfield(R(1).spline_data,item_name)    
        switch m.plotinfo.color_coding
            case 'error'                
                for i_it = 1:m.Niter
                    % spline function
                    h(i_it) = plot(m.plotinfo.ax(ind_item),...
                                    R(i_it).spline_data.(item_name).t,R(i_it).spline_data.(item_name).m,...
                                    '-','Color',clist(i_it,:),'LineWidth',m.plotinfo.LW_spline);           
                end  

            case 'density'
                t = repmat(R(1).spline_data.(item_name).t',m.Niter,1);
                x = [];
                for i_it = 1:m.Niter
                    x = [x; R(i_it).spline_data.(item_name).m'];
                end

                [N,C] = hist3(m.plotinfo.ax(ind_item),[t x],[m.Ndt 100]);
                N = N./max(max(N));
                N(isinf(N))=0;
                
                h=pcolor(m.plotinfo.ax(ind_item),C{1},C{2},N');
                shading(m.plotinfo.ax(ind_item),'flat')
                colormap(m.plotinfo.ax(ind_item),clist); %freeze_colormap
        end
    else
        h = 0;
    end
end
% -------------------------------------------------------------------------------------------------------------------------
function h = include_sampled_data(R,m,ind_item)
    item_name = m.plotinfo.item_names{ind_item};    
    [clist,ind] = colormap_data_splines(R,m);
    
    if isfield(R(1).spline_data,item_name)        
        for i_it = 1:m.Niter
            t_data = R(1).raw_data.(item_name).t;
            m_data = R(ind(i_it)).data_sample.(item_name);
            plot(m.plotinfo.ax(ind_item),t_data,m_data,'o',...
                    'Color',clist(i_it,:),'LineWidth',m.plotinfo.LW_spline,'MarkerSize',m.plotinfo.MS_data)
        end  
    else
        h = 0;
    end
end
% -------------------------------------------------------------------------------------------------------------------------
function h = include_model_sim(R,m,ind_item)
    [clist,ind] = colormap_model_sim(R,m);
    
    switch m.plotinfo.color_coding
        case 'error'
            for i_it = 1:m.Niter 
                t_sim = R(ind(i_it)).t;
                x_sim = R(ind(i_it)).(m.plotinfo.fieldname)(ind_item,:);

                h(i_it) = plot(m.plotinfo.ax(ind_item),t_sim,x_sim,'-',...
                                'color',clist(i_it,:));
            end  
        case 'density'
            t_array = repmat(R(1).t',m.Niter,1);
            
            x_matrix = [];
            for i_it = 1:m.Niter
                x_matrix(i_it,:) = R(i_it).(m.plotinfo.fieldname)(ind_item,:);
            end
            x_array = x_matrix';
            x_array = x_array(:);

            [N,C] = hist3(m.plotinfo.ax(ind_item),[t_array x_array],[m.Ndt 100]);
            N = N./max(max(N));
            N(isinf(N))=0;
                        
            h=pcolor(m.plotinfo.ax(ind_item),C{1},C{2},N');
            shading(m.plotinfo.ax(ind_item),'flat')
            colormap(m.plotinfo.ax(ind_item),clist); %freeze_colormap
                        
            % annotate 67% confidence interval
            if isfield(m.plotinfo,'ci') && m.plotinfo.ci
                h_ci(1) = plot(m.plotinfo.ax(ind_item),R(1).t,mean(x_matrix)-std(x_matrix),'-.');
                h_ci(2) = plot(m.plotinfo.ax(ind_item),R(1).t,mean(x_matrix)+std(x_matrix),'-.');
                set(h_ci(:),'Color',clist(end,:)/2.5,'LineWidth',m.plotinfo.LW_sim/2)
            end
    end
end
% -------------------------------------------------------------------------------------------------------------------------
function [clist,ind,SSE_sorted] = colormap_model_sim(R,m)
    if isfield(m.plotinfo,'colormap')   %custom colormap
        c_matrix = m.plotinfo.colormap;
    else                                %default colormap:
        c_matrix = {[1 1 1] [1 0 0]};   %white to red
    end
        
    if isfield(R(1),'SSE')
        for i_it = 1:m.Niter
            SSE(i_it,1) = sum(R(i_it).SSE);
        end
        [SSE_sorted,ind] = sort(SSE,'descend');
        
        clist = define_custom_colormap(c_matrix,m.Niter);
    else
        ind = 1:m.Niter;
        clist = colormap(lines(m.Niter));
    end
    
end
% -------------------------------------------------------------------------------------------------------------------------
function [clist,ind,SSE_sorted] = colormap_data_splines(R,m)
    if isfield(m.plotinfo,'colormap')   %custom colormap
        c_matrix = m.plotinfo.colormap;
    else                                %default colormap:
        c_matrix = {[1 1 1] [0 0 1]};   %white to blue
    end

    if strcmp(m.plotinfo.color_coding,'error')
        item_names = fieldnames(R(1).spline_data);
        for i_it = 1:m.Niter        
            for ind_item = 1:length(item_names)
                item_name = item_names{ind_item};
                SSE_item(ind_item,1) = R(i_it).spline_data.(item_name).error.w .^2;
            end
            SSE(i_it,1) = sum(SSE_item);
        end
        [SSE_sorted,ind] = sort(SSE,'descend');
    else
        ind = 1:m.Niter;
    end
    clist = define_custom_colormap(c_matrix,m.Niter);
end
% -------------------------------------------------------------------------------------------------------------------------
function m = initialize_figure(m)
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
% -------------------------------------------------------------------------------------------------------------------------
function save_figure(m)
    if m.plotinfo.save
        for i_fig = 1:length(m.plotinfo.f)
            save_options.filename = [m.plotinfo.save_dir m.plotinfo.filename_fig{i_fig}];
            save_options.fig_handle = m.plotinfo.f(i_fig);
            if ~isfield(m.plotinfo,'save_format')
                save_options.eps = 1;
                save_options.png = 0;
            else
                if strcmp(m.plotinfo.save_format,'eps')
                    save_options.eps = 1;
                    save_options.png = 0;
                elseif strcmp(m.plotinfo.save_format,'png')
                    save_options.eps = 0;
                    save_options.png = 1;
                end
            end

            save_figure_to_file(save_options)
            close(m.plotinfo.f(i_fig))
        end
    end
end
% -------------------------------------------------------------------------------------------------------------------------
function annotate_graph(R,m,h,ind_item)
    
    if isfield(h,'raw_d')
        if h.raw_d(ind_item) ~= 0;
            uistack(h.raw_d(ind_item),'top')
        end
    end
    
    
    % -- item information
    switch m.plotinfo.type
        case {'state' 'flux' 'parameter' 'observable'}            
            [~,short_name,full_name,unit] = get_info_mc(m.plotinfo.type,ind_item,m);
        case {'raw data' 'spline data' 'sampled data' 'spline+sampled data'}
            short_name = m.plotinfo.item_names{ind_item};
            full_name = R(1).raw_data.(short_name).name;
            unit = R(1).raw_data.(short_name).unit;
    end
    
    % -- axes information
    xlabel(m.plotinfo.ax(ind_item),['time [' m.info.t_unit ']'], 'FontSize', 10) % adapted to smaller fontsize
    ylabel(m.plotinfo.ax(ind_item),['[' unit ']'], 'FontSize', 10) % adapted to smaller fontsize
    if m.plotinfo.save
        title(m.plotinfo.ax(ind_item),[full_name ' (' short_name ')'])
    else
        title(m.plotinfo.ax(ind_item),[full_name ' (' short_name ')'],'FontWeight','bold', 'FontSize', 10) % adapted to smaller fontsize
    end
%    title(m.plotinfo.ax(ind_item),[short_name ': ' full_name])
    set(m.plotinfo.ax(ind_item),'Xlim',[-0.05 1.05]*m.info.t_max, 'FontSize', 10)% adapted to smaller fontsize
    

    % -- impose limited range on y-axis
    if isfield(m.plotinfo,'limit')
        switch m.plotinfo.type
            case {'state' 'flux' 'parameter'}
                if isfield(m.plotinfo.limit,m.plotinfo.fieldname)
                    set(m.plotinfo.ax(ind_item),'Ylim',m.plotinfo.limit.(m.plotinfo.fieldname)(ind_item,:));
                end
            otherwise
                if isfield(m.plotinfo.limit,'x')
                    set(m.plotinfo.ax(ind_item),'Ylim',m.plotinfo.limit.x(ind_item,:));
                end
        end
    end


    % -- add legend / colorbar
    if ind_item == m.plotinfo.Nitems
        % legend information
        if isfield(m.plotinfo,'legend') && m.plotinfo.legend
            if ~isfield(m.plotinfo,'legend_items')
                [~,~,SSE_sorted] = colormap_model_sim(R,m);
                legendlist = {};
                for i_it = 1:m.Niter
                    legendlist = [legendlist; ['\chi^2 = ' sprintf('%.2f',SSE_sorted(i_it))]];
                end
            else
                legendlist = m.plotinfo.legend_items;
            end
            legend(flipud(h.sim(:)),flipud(legendlist))
            legend boxoff
        end
        % change position of legend
%         ...

    
        % colorbar information
        if isfield(m.plotinfo,'colorbar') && m.plotinfo.colorbar && ~strcmp(m.plotinfo.type,'raw data')
            switch m.plotinfo.type
                case {'spline data' 'sampled data' 'spline+sampled data'}
                    [clist,~,SSE_sorted] = colormap_data_splines(R,m);
                otherwise
                    [clist,~,SSE_sorted] = colormap_model_sim(R,m);
            end
            
            colormap(clist)
            cbar = colorbar;        
        
            bottomlabel = sprintf('%.3g',SSE_sorted(1));
            toplabel    = sprintf('%.3g',SSE_sorted(end));

            set(cbar,'YTick',[1 m.Niter+1],'YTickLabel',{bottomlabel toplabel},'LineWidth',1)
            set(get(cbar,'Title'),'string','\chi^2')
            
            
            % move colorbar to top right
            if length(m.plotinfo.ax) < m.plotinfo.Nc
                ax_pos = get(m.plotinfo.ax(end),'Position');
            else
                ax_pos = get(m.plotinfo.ax(m.plotinfo.Nc),'Position');
            end
            cbar_pos = get(cbar,'position');

            if m.plotinfo.Nc < 3
                offset = 0.025;
            else
                offset = 0.05;
            end
            x = ax_pos(1)+ax_pos(3)+offset;
            y = ax_pos(2);
            dx = cbar_pos(3);
            dy = cbar_pos(4);
            
            set(cbar,'Position',[x y dx dy])
        end
    end   
end
% -------------------------------------------------------------------------------------------------------------------------
function fieldname = get_fieldname(plottype)
    switch plottype
        case 'state'
            fieldname = 'x';
        case 'flux'
            fieldname = 'j';
        case 'parameter'
            fieldname = 'p';
        case 'observable'
            fieldname = 'y';
    end
end
% -------------------------------------------------------------------------------------------------------------------------
end