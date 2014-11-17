function this = draw(this, name, type, pos, size, value, cb)

import AMF.*

control.name = name;
control.type = type;
control.pos = pos;
control.size = size;
control.callback = cb;
control.value = value;
control.selected = '';

this.controls.(name) = control;

this.dim(1) = max([control.pos(1) + control.size(1) + 2, this.dim(1)]);
this.dim(2) = max([control.pos(2) + control.size(2) + 2, this.dim(2)]);