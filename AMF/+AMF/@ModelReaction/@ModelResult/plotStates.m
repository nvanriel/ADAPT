function this = plotStates(this)

n = length(this.states);
r = sqrt(n);

figure;

for i = 1:n
    subplot(floor(r), ceil(r), i);
    state = this.states(i);
    
    t = this.time;
    x = state.val;
    
    plot(t, x, 'r');
end