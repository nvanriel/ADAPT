function plot_states(this)

h3 = figure('Name','States');

numstates   = size(this.states,2);
numsupls    = ceil(sqrt(numstates));

for it = 1:numstates
    subplot(numsupls,numsupls,it)
    
    val = this.states(it).val;
    plot_hist(this,this.time, val, 'xlab', 'ylab', 'red');    
end