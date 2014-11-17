function this = plot(this)

errorbar(this.source.time, this.source.val, this.source.std, 'xr');