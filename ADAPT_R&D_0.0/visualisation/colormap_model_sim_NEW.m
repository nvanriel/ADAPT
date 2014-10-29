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