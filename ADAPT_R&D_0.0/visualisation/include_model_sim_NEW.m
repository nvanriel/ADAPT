function h = include_model_sim_NEW(R,m,ind_item,varargin)
    [clist,ind] = colormap_model_sim_NEW(R,m);
    
    if ~isempty(varargin)
        i_ax = m.plotinfo.ax(varargin{1});
    else
        i_ax = m.plotinfo.ax(ind_item);
    end
    
    switch m.plotinfo.color_coding
        case 'error'
            for i_it = 1:m.Niter        
                t_sim = R(ind(i_it)).t;
                x_sim = R(ind(i_it)).(m.plotinfo.fieldname)(ind_item,:);

                h(i_it) = plot(i_ax,t_sim,x_sim,'-',...
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

            [N,C] = hist3(i_ax,[t_array x_array],[m.Ndt 100]);
            N = N./max(max(N));
            N(isinf(N))=0;
                        
            h=pcolor(i_ax,C{1},C{2},N');
            shading(i_ax,'flat')
            colormap(i_ax,clist); %freeze_colormap
                        
            % annotate 67% confidence interval
            if isfield(m.plotinfo,'ci') && m.plotinfo.ci
                h_ci(1) = plot(i_ax,R(1).t,mean(x_matrix)-std(x_matrix),'-.');
                h_ci(2) = plot(i_ax,R(1).t,mean(x_matrix)+std(x_matrix),'-.');
                set(h_ci(:),'Color',clist(end,:)/2.5,'LineWidth',m.plotinfo.LW_sim/2)
            end
    end
end