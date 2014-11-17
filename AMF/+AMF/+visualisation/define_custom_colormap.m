function clist = define_custom_colormap(c_matrix,N)

if length(c_matrix) == 3
    clist(1,:) = c_matrix{1};           %start color
    clist(ceil(N/2),:) = c_matrix{2};   %middle color
    clist(N,:) = c_matrix{3};           %end color
    
    dc1 = clist(ceil(N/2),:) - clist(1,:);
    for i1 = 2:ceil(N/2)-1
        clist(i1,:) = clist(i1-1,:) + dc1/(N-1);
    end

    dc2 = clist(N,:) - clist(ceil(N/2),:);
    for i2 = ceil(N/2)+1:N-1
        clist(i2,:) = clist(i2-1,:) + dc2/(N-1);
    end

    
elseif length(c_matrix) == 2
    clist(1,:) = c_matrix{1}; %start color
    clist(N,:) = c_matrix{2}; %end color    
    
    dc = clist(N,:)-clist(1,:);

    for i = 2:N-1
        clist(i,:) = clist(i-1,:) + dc/(N-1);
    end
end