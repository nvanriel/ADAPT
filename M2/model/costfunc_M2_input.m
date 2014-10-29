function error = costfunc_M2_input(p,p_prev,p0,u,x0,tspan,data,gene_data,R,m)


% -- compute model simulation
[t,x_sim,j_sim,y_sim] = simulate_model(tspan,x0,p,p0,u,m);


	p_diff = ( (p-p_prev) ./ p0) / (t(end)-t(1));
	p_diff = p_diff(1:length(p));

	pdreg = [
			p_diff(1)
			];

	R.p = [R.p,p];
	cr =  [];

	reg = [ R.lab1 * pdreg
			R.lab1 * cr ];

% -- weighted error: difference between model prediction and experimental data
e_data = [
		(y_sim(1,end) - data.k_dud.m(end)) ./ (data.k_dud.sd(end))
		];


% -- regularization term
if tspan(end)>0
	e_reg = (p - p_prev) ./ p0;
else
	e_reg = [];
end

% -- compute total error
error = [e_data; m.info.lambda_r*e_reg; reg];



% -- append zeros such that algorithm functions (length(error) should be at least #parameters)
if length(error)<length(p)
	N = length(p)-length(error);
	error = [error; zeros(N,1)];
end