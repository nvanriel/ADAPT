function val = getValue(this, name, i)

if nargin < 3, i = 0; end

val = this.ref.(name).val;
if i > 0
    val = val(i,:);
end