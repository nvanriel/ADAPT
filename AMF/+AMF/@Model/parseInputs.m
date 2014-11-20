function this = parseInputs(this)

if isempty(this.inputs)
    return
end

for comp = this.inputs
    
    comp.time = this.time(:);
    comp.val = zeros(size(comp.time));
    
    switch upper(comp.type)
        case 'DATA'
            if isempty(this.dataset)
                error('Can not obtain input value from dataset.');
            end

            if isempty(comp.func)
                dataField = this.dataset.ref.(comp.args{1});
                comp.initVal = dataField.src.val;
                comp.initTime = dataField.src.time; 
            else
                dataFields = get(this.dataset, comp.args{:});
                [t, val] = comp.func(dataFields);
                comp.initVal = val;
                comp.initTime = t;
            end

        case 'FUNCTION'
            t = comp.args{1};
            params = get(this, comp.args{2:end});
            
            if isempty(comp.func)
                comp.initTime = t;
                comp.initVal = [params.curr];
            else
                [t, val] = comp.func(t, params);
                comp.initVal = val;
                comp.initTime = t;
            end
    end
end