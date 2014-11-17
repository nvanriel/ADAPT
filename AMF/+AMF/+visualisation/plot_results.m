function plot_results(model,plotinfo)
    addpath(genpath(fullfile(cd,'visualisation')));
    
    load('r.mat')
%     dir = [pwd '\' settings.folder_name '\' settings.phenotype '\'];
%     load([dir sprintf('results_%s_Nit=%d_Nt=%d_seed=%d',settings.phenotype,model.options.numIter,model.options.numTimeSteps,settings.random_state)]);
   
    for it = 1:model.options.numIter  
        SSE(it,1) = sum(result.sse(:,it));
    end
    [SSE_sorted,ind] = sort(SSE,'descend');
    clist = AMF.visualisation.define_custom_colormap(plotinfo.c_matrix,model.options.numIter);

    for i_mc = 1:numel(plotinfo.model_components)
        x = plotinfo.model_components{i_mc};
        count = 0;




        for i_x = 1:numel(result.(x))
            count = count + 1;
            switch plotinfo.fig_style
                case 'subplot'
    %                 plotinfo.FS = 18;
    %                 plotinfo.LW_axes = 2;
    %                 plotinfo.LW_data = 3;
    %                 plotinfo.MS_data = 16;
    %                 plotinfo.LW_sim = 4;

                    Nr = ceil(sqrt(numel(result.(x))));
                    Nc = ceil(numel(result.(x))/Nr);

                    if i_x == 1
                        f{i_mc} = figure; %('name',[settings.phenotype ' - ' x]);
                    end
                    ax(i_x) = subplot(Nc,Nr,i_x);hold on

                case 'fig'
    %                 plotinfo.FS = 40;
    %                 plotinfo.LW_axes = 3;
    %                 plotinfo.LW_data = 4;
    %                 plotinfo.MS_data = 26;
    %                 plotinfo.LW_sim = 6;
                    f{i_mc,i_x} = figure; %('name',[settings.phenotype ' - ' x]);
                    ax(i_x) = gca;hold on

                case 'splitfig'
                    if isfield(plotinfo,'Nr')
                        Nr = plotinfo.Nr;
                    else
                        Nr = 2;
                    end
                    if isfield(plotinfo,'Nc')
                        Nc = plotinfo.Nc;
                    else
                        Nc = 2;
                    end
                    i_fig = ceil( count / ( Nr * Nc ));
                    i_subpl = count - (i_fig-1) * ( Nr * Nc );

                    if i_subpl == 1
                        f{i_fig} = figure; %('Name',[settings.phenotype ' - ' x ' [' num2str(i_fig) '/' num2str(ceil(numel(result.(x))/(Nr*Nc))) ']']);
                    end
                    ax(i_x) = subplot(Nr,Nc,i_subpl);hold on
            end
            AMF.visualisation.define_figure_details;%(plotinfo);

            T = result.(x)(i_x).time;

            switch plotinfo.plot_color 
                case 'normal'
                    for it = 1:model.options.numIter
                        X = result.(x)(i_x).val(:,it);
                        plot(T,X,'r-')
                    end

                case 'error'
                    for it = 1:model.options.numIter   
                        X = result.(x)(i_x).val(:,it);
                        plot(T,X,'-','color',clist(it,:));
                    end  

                case 'density'
                    t_array = repmat(T,model.options.numIter,1);

                    x_matrix = [];
                    for it = 1:model.options.numIter
                        x_matrix(it,:) = result.(x)(i_x).val(:,it);
                    end
                    x_array = x_matrix(:);

                    [N,C] = hist3(ax(i_x),[t_array x_array],[model.options.numTimeSteps 100]);
                    N = N./max(max(N));
                    N(isinf(N))=0;

                    h=pcolor(C{1},C{2},N');
                    shading(ax(i_x),'flat')
                    colormap(ax(i_x),clist);

                    % annotate 67% confidence interval
                    if isfield(plotinfo,'ci') && plotinfo.ci
                        h_ci(1) = plot(T,mean(x_matrix)-std(x_matrix),'-.');
                        h_ci(2) = plot(T,mean(x_matrix)+std(x_matrix),'-.');
                        set(h_ci(:),'Color',clist(end,:)/2.5,'LineWidth',20)
                    end
                case 'density2'
                    DT = 1;
                    NDX = 50;
                    Tspace = T(1):DT:T(end);
                    y_lim = get_ylim_without_outliers(result,model,x,i_x);
                    Xmin = y_lim(1);
                    Xmax = y_lim(2);                    
                    DX = ((ceil(Xmax)-floor(Xmin))/NDX);
                    Xspace = floor(Xmin) : DX : ceil(Xmax);
                    Z = zeros(length(Tspace),length(Xspace)-1);

                    for it = 1:model.options.numIter
                        t_curr = T';
                        x_curr = result.(x)(i_x).val(:,it);

                        % -- interpolate data to discretized space
                        A{it}.t = interp1(t_curr,t_curr,Tspace);
                        A{it}.x = interp1(t_curr,x_curr,A{it}.t,'linear');
                        A{it}.i = [];

                        for t_i = 1:length(Tspace)
                            for x_i = 1:length(Xspace)-1
                                dX = [Xspace(x_i) Xspace(x_i+1)];

                                left = find(A{it}.x(t_i)>=dX(1));
                                right = find(A{it}.x(t_i)<dX(2));

                                if ~isempty(left) && ~isempty(right)
                                    if left && right
                                        A{it}.i(end+1) = x_i;
                                        Z(t_i,x_i) = Z(t_i,x_i) + 1;
                                    end  
                                end
                            end
                        end
                    end

                    if isfield(plotinfo,'colortype')
                        switch plotinfo.colortype
                            case 'jet'
                                clist = colormap(jet(max(Z(:)))); %blue -> red
                            case 'black'
                                clist = define_custom_colormap({[0.9 0.9 0.9] [0 0 0]},max(Z(:))); %light grey -> black
                            case 'blue'
                                clist = define_custom_colormap({[0.8 0.8 1] [0 0 0.8]},max(Z(:))); %light blue -> dark blue
                        end
                    else
                        clist = define_custom_colormap(plotinfo.c_matrix,max(Z(:)));
                    end

                    for it = 1:model.options.numIter
                        surf_x = repmat( A{it}.t( ~isnan(A{it}.t) ),2,1);
                        surf_y = repmat( A{it}.x( ~isnan(A{it}.t) ),2,1);
                        surf_z = zeros(size(surf_x));

                        surf_c = [];
                        for t_i = 1:length(surf_x)
                            if t_i <= length(A{it}.i)
                                surf_c(t_i) = Z(t_i,A{it}.i(t_i));
                            else
                                surf_c(t_i) = 0;
                            end
                        end

                        surface(surf_x,surf_y,surf_z,repmat(surf_c,2,1),...
                                'FaceColor','none','EdgeColor','interp','LineWidth',1);
                    end
                    colormap(clist)
            end


            
            if ~isempty(result.(x)(i_x).data)
                plot(result.(x)(i_x).data.time,result.(x)(i_x).data.val,'kx',...
                     'MarkerSize',20,'LineWidth',3);
                he = errorbar(result.(x)(i_x).data.time,result.(x)(i_x).data.val,result.(x)(i_x).data.std,'k.',...
                              'LineWidth',3);
                AMF.visualisation.errorbar_tick(he,0.5,'units')
            end

            xlabel(['time [' model.options.time_unit ']'])

            if ~isempty(result.(x)(i_x).unit)
                ylabel([strrep(result.(x)(i_x).name,'_','-') ' [' result.(x)(i_x).unit ']'])
            else
                ylabel(strrep(result.(x)(i_x).name,'_','-'))
            end

            set(ax(i_x),'xlim',[result.(x)(i_x).time(1)-0.25 result.(x)(i_x).time(end)+0.25])
            if isfield(plotinfo,'remove_outliers') && plotinfo.remove_outliers
                set(ax(i_x),'ylim',get_ylim_without_outliers(result,model,x,i_x))
            end
        end
        
        if plotinfo.save
            save_dir = [pwd '\results\' plotinfo.plot_color '\'];
            if ~exist(save_dir,'dir')
                mkdir(save_dir)
            end
            for i_f = 1:length(f)
                s.fig_handle = f{i_f};
                if length(f) == 1
                    s.filename = [save_dir 'Nit=' num2str(model.options.numIter) '_Nt=' num2str(model.options.numTimeSteps) '_' x];
                else
                    s.filename = [save_dir 'Nit=' num2str(model.options.numIter) '_Nt=' num2str(model.options.numTimeSteps) '_' x num2str(i_f)];
                end
                s.eps = 0;
                s.png = 1;
                save_figure_to_file(s)
                close(i_f);
            end
        end
    end
end

function y_lim = get_ylim_without_outliers(result,model,x,i_x)
    minlist = [];
    maxlist = [];
    for it = 1:model.options.numIter
        minlist(end+1,1) = min(result.(x)(i_x).val(:,it));
        maxlist(end+1,1) = max(result.(x)(i_x).val(:,it));
    end
    minlist_sorted = sort(minlist,'ascend');
    minQ1 = minlist_sorted(ceil(0.25*length(minlist)));
    minQ3 = minlist_sorted(ceil(0.75*length(minlist)));
    
    maxlist_sorted = sort(maxlist,'ascend');
    maxQ1 = maxlist_sorted(ceil(0.25*length(maxlist)));
    maxQ3 = maxlist_sorted(ceil(0.75*length(maxlist)));

    w=2;
    i_min_outliers = (minlist > minQ3 + w*(minQ3 - minQ1) | minlist < minQ1 - w*(minQ3 - minQ1));
    i_max_outliers = (maxlist > maxQ3 + w*(maxQ3 - maxQ1) | maxlist < maxQ1 - w*(maxQ3 - maxQ1));

    
    y_lim(1) = min(minlist(~i_min_outliers));
    y_lim(2) = max(maxlist(~i_max_outliers));
end