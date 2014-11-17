function this = render(this)

this.id = figure;
this.color = get(this.id, 'color');

set(this.id, 'Position', [0, 0, fliplr(size(this))]);

structfun(@this.renderControl, this.controls);