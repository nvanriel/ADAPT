function E = minGlucReg(model)

Ra = model.ref.Ra_g;

tmp = cumtrapz(model.time, Ra.curr);
AUC_Ra = tmp(end);

Gtot = model.ref.Gtot;

E = AUC_Ra - Gtot.val;