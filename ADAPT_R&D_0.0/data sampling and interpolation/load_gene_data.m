function gene_data = load_gene_data(m)
    if isfield(m,'phenotype')
        filename_data = ['gene_data_' m.modelname '_' m.phenotype '.mat'];
        if exist(filename_data,'file')
            load(filename_data)
        else
            gene_data = feval(['load_gene_data_' m.modelname],m.phenotype);
        end

    else
        filename_data = ['gene_data_' m.modelname '.mat'];
        if exist(filename_data,'file')
            load(filename_data)
        else
            gene_data = feval(['load_gene_data_' m.modelname]);
        end
    end
end