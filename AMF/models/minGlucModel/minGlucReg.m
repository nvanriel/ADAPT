% minGlucReg.m
% Regularization function of the minimal
% glucose model by Dalla Man et al.
function E = minGlucReg(model)

Ra = model.ref.Ra_g;
Gtot = model.ref.Gtot;

E = AUC(Ra) - Gtot.val;