function handle = renderEdit(this, control)

UISize = size(this);

xpos = control.pos(2) * this.scale;
ypos = UISize(1) - control.pos(1) * this.scale - this.scale * 2;
xsize = control.size(2) * this.scale;
ysize = control.size(1) * this.scale;

pos = [xpos, ypos];
dim = [xsize, ysize];

label = uicontrol('Parent', this.id, 'Style', 'text', 'Position', [pos(1), pos(2), .5 * dim(1), dim(2)], 'String', control.name, 'BackgroundColor', this.color);

handle = uicontrol('Parent', this.id, 'Style', 'edit', 'Position', [pos(1) + .5 * dim(1), pos(2),.5 *dim(1),dim(2)],'String',control.value, 'BackgroundColor', [1,1,1]);
set(handle, 'Callback', {@callback, this, control.name});

function callback(handle, ~, this, name)

string = get(handle, 'String');
value = str2double(string);

this.controls.(name).value = value;
callback = this.controls.(name).callback;

if ~isempty(callback)
    if isa(callback, 'cell')
        cb = callback{1};
        args = callback(2:end);
    else
        cb = callback;
        args = {};
    end
    cb(this, args{:});
end