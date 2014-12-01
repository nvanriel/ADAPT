classdef ModelResult < handle
    properties
        predictor
        states
        constants
        reactions
        inputs
        parameters
        
        sse
        result
        time
        mStruct
        options
        
        ref = struct()
    end
    methods
        function this = ModelResult(model, result)
            this.result = result;
            this.time = result(1).time;
            this.sse = [result.sse];
            this.mStruct = getInputStructMex(model);
            this.options = model.options;
            
            this.predictor = getStruct(model.predictor);
            if ~isempty(model.states), this.states = getStruct(model.states); end
            if ~isempty(model.constants), this.constants = getStruct(model.constants); end
            if ~isempty(model.reactions), this.reactions = getStruct(model.reactions); end
            if ~isempty(model.inputs), this.inputs = getStruct(model.inputs); end
            if ~isempty(model.parameters), this.parameters = getStruct(model.parameters); end
            
            for i = 1:length(this.result)
                for j = 1:length(this.states)
                    this.states(j).val(:,i) = this.result(i).x(:,j);
                    
                    if this.states(j).obs
                        oxi = double(this.result(1).oxi);
                        oxi(logical(oxi)) = this.result(1).oxdi;
                        oxdi = oxi(j);
                        if i == 1
                            dt = this.result(i).dt;        % fit time
                            dd = this.result(i).dd(:,oxdi); % data val
                            ds = this.result(i).ds(:,oxdi); % data std

                            this.states(j).dt = dt(~isnan(dd));
                            this.states(j).dd = dd(~isnan(dd));
                            this.states(j).ds = ds(~isnan(dd));
                        end
                        
                        if ~isempty(this.result(i).idd)
                            idd = this.result(i).idd(:,oxdi);
                            ids = this.result(i).ids(:,oxdi);
                            
                            this.states(j).idd(:,i) = idd;
                            this.states(j).ids(:,i) = ids;
                        end
                    end
                    
                    this.ref.(this.states(j).name) = this.states(j);
                end
                for j = 1:length(this.reactions)
                    this.reactions(j).val(:,i) = this.result(i).v(:,j);
                    
                    if this.reactions(j).obs
                        ofi = double(this.result(1).ofi);
                        ofi(logical(ofi)) = this.result(1).ofdi;
                        ofdi = ofi(j);
                        if i == 1
                            dt = this.result(i).dt;        % fit time
                            dd = this.result(i).dd(:,ofdi); % data val
                            ds = this.result(i).ds(:,ofdi); % data std

                            this.reactions(j).dt = dt(~isnan(dd));
                            this.reactions(j).dd = dd(~isnan(dd));
                            this.reactions(j).ds = ds(~isnan(dd));
                        end

                        if ~isempty(this.result(i).idd)
                            idd = this.result(i).idd(:,ofdi);
                            ids = this.result(i).ids(:,ofdi);

                            this.reactions(j).idd(:,i) = idd;
                            this.reactions(j).ids(:,i) = ids;
                        end
                    end
                    
                    this.ref.(this.reactions(j).name) = this.reactions(j);
                end
                for j = 1:length(this.inputs)
                    this.inputs(j).val(:,i) = this.result(i).u(:,j);
                    
                    this.ref.(this.inputs(j).name) = this.inputs(j);
                end
                for j = 1:length(this.parameters)
                    this.parameters(j).val(:,i) = this.result(i).p(:,j);
                    
                    this.ref.(this.parameters(j).name) = this.parameters(j);
                end
                for j = 1:length(this.constants)
                    this.ref.(this.constants(j).name) = this.constants(j);
                end
            end
        end
    end
end