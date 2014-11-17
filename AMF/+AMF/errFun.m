% AMF.errFun
function err = errFun(comp)

idx = comp.data.fitIdx;
err = (comp.data.source.val(:)-comp.curr(idx))./comp.data.source.std(:);