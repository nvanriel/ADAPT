function error = costfunc_M2(p,p_prev,p0,u,x0,tspan,data,gene_data,R,m)


% -- compute model simulation
[t,x_sim,j_sim,y_sim] = simulate_model(tspan,x0,p,p0,u,m);


	p_diff = ( (p-p_prev) ./ p0) / (t(end)-t(1));
	p_diff = p_diff(1:length(p));

	mindiff = 1e-6;

	pdreg = [
			sqrt(1/3) * p_diff(14) ./ (max([gene_data.ldlr.diff, mindiff]))
			sqrt(1/3) * p_diff(14) ./ (max([gene_data.vldlr.diff, mindiff]))
			sqrt(1/3) * p_diff(14) ./ (max([gene_data.lrp1.diff, mindiff]))
			sqrt(1/1) * p_diff(13) ./ (max([gene_data.lpl.diff, mindiff]))
			sqrt(1/3) * p_diff(1) ./ (max([gene_data.sqs.diff, mindiff]))
			sqrt(1/3) * p_diff(1) ./ (max([gene_data.hmgcoared.diff, mindiff]))
			sqrt(1/3) * p_diff(1) ./ (max([gene_data.srebp2.diff, mindiff]))
			sqrt(1/3) * p_diff(2) ./ (max([gene_data.abcg1.diff, mindiff]))
			sqrt(1/3) * p_diff(2) ./ (max([gene_data.abcg5.diff, mindiff]))
			sqrt(1/3) * p_diff(2) ./ (max([gene_data.cyp7a1.diff, mindiff]))
			sqrt(1/5) * p_diff(7) ./ (max([gene_data.gpat.diff, mindiff]))
			sqrt(1/5) * p_diff(7) ./ (max([gene_data.fas.diff, mindiff]))
			sqrt(1/5) * p_diff(7) ./ (max([gene_data.me1.diff, mindiff]))
			sqrt(1/5) * p_diff(7) ./ (max([gene_data.srebp1c.diff, mindiff]))
			sqrt(1/5) * p_diff(7) ./ (max([gene_data.scd1.diff, mindiff]))
			sqrt(1/5) * p_diff(22) ./ (max([gene_data.gpat.diff, mindiff]))
			sqrt(1/5) * p_diff(22) ./ (max([gene_data.fas.diff, mindiff]))
			sqrt(1/5) * p_diff(22) ./ (max([gene_data.me1.diff, mindiff]))
			sqrt(1/5) * p_diff(22) ./ (max([gene_data.srebp1c.diff, mindiff]))
			sqrt(1/5) * p_diff(22) ./ (max([gene_data.scd1.diff, mindiff]))
			sqrt(1/4) * p_diff(8) ./ (max([gene_data.lcad.diff, mindiff]))
			sqrt(1/4) * p_diff(8) ./ (max([gene_data.aox.diff, mindiff]))
			sqrt(1/4) * p_diff(8) ./ (max([gene_data.hmgcoas.diff, mindiff]))
			sqrt(1/4) * p_diff(8) ./ (max([gene_data.ucp2.diff, mindiff]))
			sqrt(1/1) * p_diff(15) ./ (max([gene_data.mtp.diff, mindiff]))
			sqrt(1/1) * p_diff(16) ./ (max([gene_data.mtp.diff, mindiff]))
			sqrt(1/1) * p_diff(21) ./ (max([gene_data.apob.diff, mindiff]))
			sqrt(1/2) * p_diff(19) ./ (max([gene_data.cd36.diff, mindiff]))
			sqrt(1/2) * p_diff(19) ./ (max([gene_data.ap2.diff, mindiff]))
			p_diff([3 4 5 6 9 10 11 12 17 18 20 ])];
	R.p = [R.p,p];
	cr = [
		sqrt(1/3) * ( 1-corrT(R.p(14,:),gene_data.ldlr.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(14,:),gene_data.vldlr.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(14,:),gene_data.lrp1.gtot) )
		sqrt(1/1) * ( 1-corrT(R.p(13,:),gene_data.lpl.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(1,:),gene_data.sqs.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(1,:),gene_data.hmgcoared.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(1,:),gene_data.srebp2.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(2,:),gene_data.abcg1.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(2,:),gene_data.abcg5.gtot) )
		sqrt(1/3) * ( 1-corrT(R.p(2,:),gene_data.cyp7a1.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(7,:),gene_data.gpat.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(7,:),gene_data.fas.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(7,:),gene_data.me1.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(7,:),gene_data.srebp1c.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(7,:),gene_data.scd1.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(22,:),gene_data.gpat.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(22,:),gene_data.fas.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(22,:),gene_data.me1.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(22,:),gene_data.srebp1c.gtot) )
		sqrt(1/5) * ( 1-corrT(R.p(22,:),gene_data.scd1.gtot) )
		sqrt(1/4) * ( 1-corrT(R.p(8,:),gene_data.lcad.gtot) )
		sqrt(1/4) * ( 1-corrT(R.p(8,:),gene_data.aox.gtot) )
		sqrt(1/4) * ( 1-corrT(R.p(8,:),gene_data.hmgcoas.gtot) )
		sqrt(1/4) * ( 1-corrT(R.p(8,:),gene_data.ucp2.gtot) )
		sqrt(1/1) * ( 1-corrT(R.p(15,:),gene_data.mtp.gtot) )
		sqrt(1/1) * ( 1-corrT(R.p(16,:),gene_data.mtp.gtot) )
		sqrt(1/1) * ( 1-corrT(R.p(21,:),gene_data.apob.gtot) )
		sqrt(1/2) * ( 1-corrT(R.p(19,:),gene_data.cd36.gtot) )
		sqrt(1/2) * ( 1-corrT(R.p(19,:),gene_data.ap2.gtot) )
			];

	reg = [R.lab1 * pdreg
			R.lab1 * cr ];

% -- weighted error: difference between model prediction and experimental data
e_data = [
		(y_sim(1,end) - data.hep_TG.m(end)) ./ (data.hep_TG.sd(end))
		(y_sim(2,end) - data.hep_CE.m(end)) ./ (data.hep_CE.sd(end))
		(y_sim(3,end) - data.hep_FC.m(end)) ./ (data.hep_FC.sd(end))
		(y_sim(4,end) - data.pl_TC.m(end)) ./ (data.pl_TC.sd(end))
		(y_sim(5,end) - data.pl_HDL_C.m(end)) ./ (data.pl_HDL_C.sd(end))
		(y_sim(6,end) - data.pl_VLDL_TG.m(end)) ./ (data.pl_VLDL_TG.sd(end))
		(y_sim(7,end) - data.pl_FFA.m(end)) ./ (data.pl_FFA.sd(end))
		(y_sim(8,end) - data.VLDL_TG_C_ratio.m(end)) ./ (data.VLDL_TG_C_ratio.sd(end))
		(y_sim(9,end) - data.VLDL_diameter.m(end)) ./ (data.VLDL_diameter.sd(end))
		(y_sim(10,end) - data.VLDL_TG_production.m(end)) ./ (data.VLDL_TG_production.sd(end))
		(y_sim(11,end) - data.hep_DNL.m(end)) ./ (data.hep_DNL.sd(end))
		(y_sim(12,end) - data.jTG_Oxi.m(end)) ./ (data.jTG_Oxi.sd(end))
		(y_sim(13,end) - data.hepTGuptake_Olivecrona.m(end)) ./ (data.hepTGuptake_Olivecrona.sd(end))
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