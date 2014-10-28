function [t_sim,x_sim,j_sim,y_sim] = simulate_model(tspan,x0,p,p0,u,m)

    %% states
    if isfield(m.info,'mexfile')
        [t_sim,x_sim] = feval(m.info.mexfile,tspan,x0,p,u,[1e-6 1e-8 10]);
    else
        [t_sim,x_sim] = ode15s(m.info.odefile,tspan,x0,m.info.ode_options,p,u,m);
        t_sim = t_sim';
        x_sim = x_sim';
    end
    

    %% fluxes & observables
    for i_t = 1:length(t_sim)
        j_sim(:,i_t) = feval(m.info.fluxfile,t_sim(i_t),x_sim(:,i_t),p,u,m)';
        y_sim(:,i_t) = feval(m.info.observfile,t_sim(i_t),x_sim(:,i_t),j_sim(:,i_t),p,u,m);
    end    
end