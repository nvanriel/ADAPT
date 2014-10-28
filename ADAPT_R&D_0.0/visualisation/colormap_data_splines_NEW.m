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