% AMF.errFunStep
function err = errFunStep(comp, ts)

err = (comp.data.val(ts)-comp.curr(:))./comp.data.std(ts);