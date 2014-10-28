function annotate_graph(R,m,h,ind_item,varargin)
    if isfield(h,'raw_d')
        uistack(h.raw_d(ind_item),'top')
    end
    
    
    % -- item information
    switch m.plotinfo.type
        case {'state' 'flux' 'parameter' 'observable'}            
            [~,short_name,full_name,unit] = get_info_mc(m.plotinfo.type,ind_item,m);
            i_ax = m.plotinfo.ax(ind_item);
        case {'raw data' 'spline data' 'sampled data' 'spline+sampled data'}
            short_name = m.plotinfo.item_names{ind_item};
            full_name = R(1).raw_data.(short_name).name;
            unit = R(1).raw_data.(short_name).unit;
            i_ax = m.plotinfo.ax(ind_item);
        case 'custom'
            short_name = varargin{1};
            full_name = varargin{2};
            unit = varargin{3};
            if length(varargin)>3
                i_ax = m.plotinfo.ax(varargin{4});
            else
                i_ax = m.plotinfo.ax(ind_item);
            end
    end
    
    % -- axes information
    xlabel(i_ax,['time [' m.info.t_unit ']'])
    ylabel(i_ax,['[' unit ']'])
    title(i_ax,full_name,'FontWeight','bold')
%     if m.plotinfo.save
%         title(i_ax,[full_name ' (' short_name ')'])
%     else
%         title(i_ax,[full_name ' (' short_name ')'],'FontWeight','bold')
%     end
%     title(i_ax,[short_name ': ' full_name])
    set(i_ax,'Xlim',[-0.05 1.05]*m.info.t_max)
    

    % -- impose limited range on y-axis
    if isfield(m.plotinfo,'limit')
        switch m.plotinfo.type
            case {'state' 'flux' 'parameter'}
                if isfield(m.plotinfo.limit,m.plotinfo.fieldname)
                    set(i_ax,'Ylim',m.plotinfo.limit.(m.plotinfo.fieldname)(ind_item,:));
                end
            otherwise
                if isfield(m.plotinfo.limit,'x')
                    set(i_ax,'Ylim',m.plotinfo.limit.x(ind_item,:));
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
            
            
            %move colorbar to top right
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