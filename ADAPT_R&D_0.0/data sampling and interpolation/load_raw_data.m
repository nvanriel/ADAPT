function data = load_raw_data(m)
    if isfield(m,'phenotype')
        filename_data = ['data_' m.modelname '_' m.phenotype '.mat'];
        if exist(filename_data,'file')
            load(filename_data)
        else
            data = feval(['load_data_' m.modelname],m.phenotype);
        end

    else
        filename_data = ['data_' m.modelname '.mat'];
        if exist(filename_data,'file')
            load(filename_data)
        else
            data = feval(['load_data_' m.modelname]);
        end
    end
end