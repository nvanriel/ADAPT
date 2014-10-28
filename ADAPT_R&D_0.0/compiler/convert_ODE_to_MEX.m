function filename_MEX = convert_ODE_to_MEX(m)

    filename_ODE = [func2str(m.info.odefile) '.m'];
    filename_MEX = ['MEX_' m.modelname];

    if ~exist(filename_MEX,'file')
        convertToC(m,filename_ODE);
        compileC(filename_MEX)
                        
        movefile([filename_MEX '.mexw64'],['model/' filename_MEX '.mexw64'])
        filename_MEX = str2func(filename_MEX);
                
        disp([char(10) ' ~~~ compiling successful; MEX file generated'])
    else
        filename_MEX = str2func(filename_MEX);
    end
end