function x = computeStates(this, t, x0, p, uvec)

if ~this.options.useMex
    mStruct = this.mStruct;
    [~, x] = ode15s(this.functions.ODE, t, x0, this.options.odeTol, p, uvec, mStruct);
else
    [~,x] = this.functions.ODEC(t, x0, p, uvec, this.options.odeTol);
    x = x';
end