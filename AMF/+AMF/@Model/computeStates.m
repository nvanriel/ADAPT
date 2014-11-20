function x = computeStates(this, t, x0, p)

if ~this.options.useMex
    mStruct = this.mStruct;
    [~, x] = ode15s(this.functions.ODE, t, x0, this.options.odeTol, p, getInputsMex(this), mStruct);
else
    [~,x] = this.functions.ODEC(t, x0, p, getInputsMex(this), this.options.odeTol);
    x = x';
end