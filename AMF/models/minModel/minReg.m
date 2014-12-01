function E = minReg(model, m, d)

r = model.result;

% C-pep HE
ISRi = trapz(r.time, r.vcurr(:, m.v.ISR));
IDRi = trapz(r.time, r.vcurr(:, m.v.IDR));

HE = 1 - IDRi / ISRi;

% Gluc RA
AUC_Ra = trapz(r.time, r.vcurr(:, m.v.Ra_g));

E = [(HE - m.c.HEi) * 1; AUC_Ra - m.c.Gtot];