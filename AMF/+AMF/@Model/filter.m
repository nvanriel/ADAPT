function compList = filter(this, func)

idx = cellfun(func, this.list);
compList = this.list(idx);