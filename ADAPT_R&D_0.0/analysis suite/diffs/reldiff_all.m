function ratios = reldiff_all(folder_targ, folder_ref, common, time_span)
% obtain all ratios of parameters between model results in folder1 relative
% to model results in folder2

cd(folder_targ)
load(['results/Niter=' num2str(common.Niter) ', Ndt=' num2str(common.Ndt) '_target_predictions/result.mat']);
cd ..

pars_folder_targ = zeros(common.nmbr_of_pars,1);
for par_ind = 1:common.nmbr_of_pars
    par_cum1 = 0;
    for i = 1:common.Niter
       par_cum1 = par_cum1 + mean(R(i).p(par_ind,time_span)); 
    end 
    pars_folder_targ(par_ind) = par_cum1/common.Niter;
end


cd(folder_ref)
load(['results/Niter=' num2str(common.Niter) ', Ndt=' num2str(common.Ndt) '_reference_predictions/result.mat']);
cd ..
pars_folder_ref = zeros(common.nmbr_of_pars,1);

for par_ind = 1:common.nmbr_of_pars
    par_cum2 = 0;
    for i = 1:common.Niter
       par_cum2 = par_cum2 + mean(R(i).p(par_ind,time_span)); 
    end
    pars_folder_ref(par_ind) = par_cum2/common.Niter;
end

ratios = pars_folder_targ./pars_folder_ref;
end

