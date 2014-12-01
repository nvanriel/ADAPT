function this = parseInputs(this)

if isempty(this.inputs)
    return
end

uidx = [];
upidx = [];
uvec = [];

for comp = this.inputs
    
    switch upper(comp.type)
        case 'DATA'
            if isempty(this.dataset)
                error('Can not obtain input value from dataset.');
            end

            dataField = this.dataset.ref.(comp.args{1});
            comp.initVal = dataField.curr.val;
            comp.initTime = dataField.src.time;
            
            uidx = [uidx zeros(1,length(comp.initVal)) zeros(1,length(comp.initTime))];
            uvec = [uvec comp.initVal(:)' comp.initTime(:)'];

        case 'FUNCTION'
            t = comp.args{1};
%             params = get(this, comp.args{2:end});
            pnames = comp.args(2:end);
            
            pidx = cellfun(@(p) this.ref.(p).index, pnames);
            upidx = [upidx pidx];

            comp.initTime = t;
%             comp.initVal = [params.curr];
            comp.initVal = this.result.pcurr(pidx);
            
            uidx = [uidx ones(1, length(pnames)) zeros(1,length(comp.initTime))];
            uvec = [uvec comp.initVal(:)' comp.initTime(:)'];
    end
    
end

this.result.uidx = logical(uidx);
this.result.upidx = upidx;
this.result.uvec = uvec;