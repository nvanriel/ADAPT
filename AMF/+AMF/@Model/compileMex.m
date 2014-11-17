function compileMex(this)

% -----------------------------------------------------
% MEX
%

if exist('convertToC') && exist('compileC')
    clear mex
    
    inputFn = func2str(this.functions.ODEMex);
    outputFn = func2str(this.functions.ODEC);

    convertToC(getInputStructMex(this), [inputFn, '.m']);
    compileC([pwd, '\', this.compileDir , outputFn]);
else
    fprintf('Add paths of odemex toolbox before compiling the model!\n');
end