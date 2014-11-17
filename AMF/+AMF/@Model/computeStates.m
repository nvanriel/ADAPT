function x = computeStates(this, t, x0, p)

mStruct = getInputStruct(this);
if ~this.options.useMex
    [~, x] = ode15s(this.functions.ODE, t, x0, this.options.odeTol, p, mStruct);
else
    [~,x] = this.functions.ODEC(t, x0, p, getInputsMex(this), this.options.odeTol);
    x = x';
end