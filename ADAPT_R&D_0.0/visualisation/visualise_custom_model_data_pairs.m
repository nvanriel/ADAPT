function m = visualise_custom_model_data_pairs(R,m)

m.plotinfo.type = 'custom';
m = initialize_figure_NEW(m);

if m.plotinfo.custom.empty_axes
    m.plotinfo.filename_fig{1} = 'axes';
end

valid_model_fieldnames = {'s' 'j' 'p' 'y'};
valid_model_components = {'x' 'j' 'p' 'y'};


for i_item = 1:length(m.plotinfo.custom.mc)
    i_ax = m.plotinfo.ax(i_item);
    curr_model_name = char(m.plotinfo.custom.mc{i_item});
    curr_data_name  = char(m.plotinfo.custom.dc{i_item});
    
    % -- detect fieldname of model component
    clear fn mc
    for i_fn = 1:length(valid_model_fieldnames)
        if isfield(m.(valid_model_fieldnames{i_fn}),curr_model_name)
            fn = valid_model_fieldnames{i_fn};
            mc = valid_model_components{i_fn};
        end
    end
    
    % -- plot model simulation
    if ~isempty(curr_model_name)
        m.plotinfo.fieldname = mc;
        ind_item = m.(fn).(curr_model_name);
        if ~m.plotinfo.custom.empty_axes
            include_model_sim_NEW(R,m,ind_item,i_item);
        end
    end
    
    % -- plot data
    if ~isempty(curr_data_name)
        data_t = m.raw_data.(curr_data_name).t;
        data_m = m.raw_data.(curr_data_name).m;
        data_sd = m.raw_data.(curr_data_name).sd;
        if ~m.plotinfo.custom.empty_axes
            errorbar(i_ax,data_t,data_m,data_sd,'kx')
        end
    end
    
    % -- annotate graph
    if ~isempty(curr_model_name)
        information = m.info.(mc){ind_item};
        if length(information)>3
            short_name = information{4};
        else
            short_name = information{1};
        end
        full_name = information{2};
        unit = information{3};
    elseif ~isempty(curr_data_name)
        short_name = curr_data_name;
        full_name = m.raw_data.(curr_data_name).name;
        unit = m.raw_data.(curr_data_name).unit;
    end
    annotate_graph_NEW(R,m,[],ind_item,short_name,full_name,unit,i_item)
    
    
    % -- remove axes and labels if figure is saved
    if ~m.plotinfo.custom.empty_axes && m.plotinfo.save
        set(i_ax,'Visible','off')
    elseif isempty(curr_model_name) && isempty(curr_data_name)
        set(i_ax,'Visible','off')
    end
    
    % -- set limits
    if isfield(m.plotinfo.custom,'ylimit')
        set(i_ax,'YLim',m.plotinfo.custom.ylimit(i_item,:))
    end
end

% -- save figure(s)
save_figure_NEW(m)