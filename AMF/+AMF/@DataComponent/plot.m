function this = plot(this)

if any(this.src.std)
    errorbar(this.src.time, this.src.val, this.src.std, 'xr');
else
    plot(this.src.time, this.src.val, 'xr');
end