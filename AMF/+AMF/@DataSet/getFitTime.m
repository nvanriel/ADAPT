function t = getFitTime(this)

t = [];

for i = 1:length(this.fields)
    df = this.fields(i);
    if df.obs
        t = [t df.src.time(:)'];
    end
end

t = sort(unique(t));