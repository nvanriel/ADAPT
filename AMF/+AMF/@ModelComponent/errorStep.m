function err = errorStep(this, ts)

err = (this.data.val(ts)-this.curr(:))./this.data.std(ts);