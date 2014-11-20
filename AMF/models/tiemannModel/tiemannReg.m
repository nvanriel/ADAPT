% additional regularization term Tiemann model
function reg = tiemannReg(model)

Vm_TG_prod = model.ref.Vm_TG_prod;
Vm_TG_ER_prod = model.ref.Vm_TG_ER_prod;

reg = (Vm_TG_prod.curr + Vm_TG_ER_prod.curr - Vm_TG_prod.prev - Vm_TG_ER_prod.prev) / (Vm_TG_prod.init + Vm_TG_ER_prod.init);