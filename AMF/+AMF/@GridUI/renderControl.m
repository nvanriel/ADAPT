function handle = renderControl(this, control)

switch control.type
    case 'EDIT'
        handle = renderEdit(this, control);
    case 'AXES'
        handle = renderAxes(this, control);
    case 'LISTBOX'
        handle = renderListBox(this, control);
        
    otherwise
        handle = 0;
end

this.handles.(control.name) = handle;