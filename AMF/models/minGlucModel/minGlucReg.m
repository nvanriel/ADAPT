function E = minGlucReg(model, m, d)

r = model.result;

AUC = trapz(r.time, r.vcurr(:, m.v.Ra_g));

E = AUC - m.c.Gtot;