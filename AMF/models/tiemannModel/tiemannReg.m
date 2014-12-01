function reg = tiemannReg(model, m, d)

r = model.result;

reg = (r.pcurr(m.p.Vm_TG_prod) + r.pcurr(m.p.Vm_TG_ER_prod) - r.pprev(m.p.Vm_TG_prod) - r.pprev(m.p.Vm_TG_ER_prod)) / (r.pinit(m.p.Vm_TG_prod) + r.pinit(m.p.Vm_TG_ER_prod));