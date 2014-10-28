function [D,m] = check_data_splines(m)

    raw_data = load_raw_data(m);
    m = feval(['initialize_model_' m.modelname],m,raw_data);
    m = define_default_options(m);    
    
    plot_spline = 1;
    plot_statistics = 0;
    
    if plot_statistics
        define_figure_details('fullscreen');
        for j = 1:3
            ax(j)=subplot(2,2,j);hold on
        end
    end
    
    
    if ~isfield(m.info,'sd_weight')
        sd_weight = [1 0.9 0.8 0.5 0.1];
    else
        sd_weight = m.info.sd_weight;
    end
    if ~isfield(m.info,'smooth')
        exp_min = -4;
        exp_max = -4;
        p_smooth = logspace(exp_min,exp_max,length(exp_min:exp_max));%[1e-5 1e-4 1e-3];
    else
        p_smooth = m.info.smooth;
    end
    
    
    for i1 = 1:length(sd_weight)
        m.info.sd_weight = sd_weight(i1);        
        
        for i2 = 1:length(p_smooth)
            m.info.smooth = p_smooth(i2);
            [D,m] = get_spline_data(m,raw_data);

            if plot_spline
                D(1).raw_data = raw_data;
    %             m.plotinfo.color_coding = 'error';
                m.plotinfo.color_coding = 'density';
    %             visualise_results(D,m,{'spline data' 'sampled data'})
                visualise_results(D,m,{'spline+sampled data'})
            end


            if plot_statistics
                item_names = fieldnames(D(1).spline_func);
                for i_it = 1:m.Niter        
                    for ind_item = 1:length(item_names)
                        item_name = item_names{ind_item};

                        ABE_item(ind_item,1) = D(i_it).spline_data.(item_name).error.abs;
                        SSE_item(ind_item,1) = D(i_it).spline_data.(item_name).error.w;

                        dx = diff(D(i_it).spline_data.(item_name).m,1);
                        zc_count = 0;
                        for j = 2:m.Ndt-1
                            if ( dx(j)>0 && dx(j-1)<0 ) || ( dx(j)<0 && dx(j-1)>0 )
                                zc_count = zc_count+1;
                            end
                        end            
                        ZC_item(ind_item,1) = zc_count;
                    end

                    X(i_it,1) = sum(ABE_item);
                    X(i_it,2) = sum(SSE_item);
                    X(i_it,3) = sum(ZC_item);
                end  

                ylabel_list = {'absolute error'
                               'weighted error'
                               '# zero-crossings'};        
                clist = colormap(lines(3));
                for j = 1:3
                    h1 = plot(ax(j),[m.info.smooth m.info.smooth],...
                                    [mean(X(:,j))-std(X(:,j)) mean(X(:,j))+std(X(:,j))],... %67%confidence interval: m +/- sd
                                    'color',[0.7 0.7 0.7],'LineWidth',12);
                    h2 = plot(ax(j),m.info.smooth,X(:,j),'o',...                         %actual values
                                    'color',clist(j,:),'MarkerSize',6);
                    h3 = plot(ax(j),m.info.smooth,median(X(:,j)),'x',...                 %median
                                    'color',clist(j,:)/2,'MarkerSize',22,'LineWidth',5);

                    xlabel(ax(j),'smoothing parameter')
                    ylabel(ax(j),ylabel_list{j})
                    set(ax(j),'XScale','log','Xlim',[10^(exp_min-1) 10^(exp_max+1)],...
                        'XTick',logspace(exp_min,exp_max,length(exp_min:exp_max)))
                end
            end
        end
        if plot_statistics
            L = legend([h3(1) h2(1) h1(1)],{'median','individual values','m +/- sd'}); legend boxoff
            set(L,'position',get(L,'position')+[0.5 0 0 0])
        end
    end
end