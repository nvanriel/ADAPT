function ratio = reldiff(folder_targ, folder_ref,Niter, Ndt, par_index, time_span)
%calculate difference between the parameter value predictions for two
%models/ predictions at specified time span

cd(folder_targ)
load(['results/Niter=' num2str(Niter) ', Ndt=' num2str(Ndt) '_target_predictions/result.mat']);
cd ..

par_cum1 = 0;
for i = 1:m.Niter
   par_cum1 = par_cum1 + R(i).p(par_index,time_span); 
end 
    
cd(folder_ref)
load(['results/Niter=' num2str(Niter) ', Ndt=' num2str(Ndt) '_reference_predictions/result.mat']);
cd ..

par_cum2 = 0;
for i = 1:m.Niter
   par_cum2 = par_cum2 + R(i).p(par_index,time_span); 
end

% ratio = target/ reference predictions
ratio = par_cum1 / par_cum2;

end



