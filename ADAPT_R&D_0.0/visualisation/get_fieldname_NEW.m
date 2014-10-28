function fieldname = get_fieldname(plottype)
    switch plottype
        case 'state'
            fieldname = 'x';
        case 'flux'
            fieldname = 'j';
        case 'parameter'
            fieldname = 'p';
        case 'observable'
            fieldname = 'y';
    end
end