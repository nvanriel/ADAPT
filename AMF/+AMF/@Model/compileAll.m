function compileAll(this)

clear mex

compileODE(this);
compileODEMex(this);
compileInputs(this);
compileReactions(this);

if this.options.useMex
    compileMex(this);
end

addpath(this.compileDir);