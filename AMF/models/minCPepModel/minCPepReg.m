function E = minCPepReg(model, m, d)

r = model.result;

ISRi = trapz(r.time, r.vcurr(:, m.v.ISR));
IDRi = trapz(r.time, r.vcurr(:, m.v.IDR));

HE = 1 - IDRi / ISRi;

E = (HE - .4) * 100;