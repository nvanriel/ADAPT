function err = error(this)

idx = this.data.fitIdx;
err = (this.data.source.val(:)-this.curr(idx))./this.data.source.std(:);