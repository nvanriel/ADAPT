function [f,J] = useObserver( obsFunc, simFunc, pars )

if nargout == 1
    [f] = feval( simFunc, pars );
    f = obsFunc( f, pars );
else
    [~, f, J] = feval( simFunc, pars );
    [f, J] = obsFunc( f, pars, J );
end
