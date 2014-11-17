function handle = renderAxes(this, control)

UISize = size(this);
pos(1) = (control.pos(2) + 2) / UISize(2) * this.scale;
pos(2) = (control.pos(1) + 2) / UISize(1) * this.scale;
dim(1) = (control.size(2) - 2) / UISize(2) * this.scale;
dim(2) = (control.size(1) - 2) / UISize(1) * this.scale;

handle = axes('Parent', this.id, 'Position', [pos(1), pos(2), dim(1), dim(2)]);