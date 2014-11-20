classdef ModelResult < handle
    properties
        predictor
        constants
        inputs
        parameters
        states
        reactions
        
        time
        sse
        
        options
    end
    methods
        function this = ModelResult(result)
            if isfield(result, 'error');
                this.sse = [result.error];
            end
            
            this.time = result(1).time(:);
            this.options = result(1).options;
            
            this.predictor = result(1).predictor;
            this.constants = result(1).constants;
            this.inputs = result(1).inputs;
            this.parameters = result(1).parameters;
            this.states = result(1).states;
            this.reactions = result(1).reactions;
            
            for i = 1:length(result)
                for j = 1:length(this.parameters)
                    this.parameters(j).val(:,i) = result(i).parameters(j).val;
                    if ~isempty(this.parameters(j).data)
                        this.parameters(j).data.val(:,i) = result(i).parameters(j).data.val;
                        this.parameters(j).data.std(:,i) = result(i).parameters(j).data.std;
                    end
                end
                for j = 1:length(this.states)
                    this.states(j).val(:,i) = result(i).states(j).val;
                    if ~isempty(this.states(j).data)
                        this.states(j).data.val(:,i) = result(i).states(j).data.val;
                        this.states(j).data.std(:,i) = result(i).states(j).data.std;
                    end
                end
                for j = 1:length(this.reactions)
%                     disp(this.reactions(j).name);
%                     disp(i);
%                     disp(j);
                    this.reactions(j).val(:,i) = result(i).reactions(j).val;
                    if ~isempty(this.reactions(j).data)
                        this.reactions(j).data.val(:,i) = result(i).reactions(j).data.val(:,1);
                        this.reactions(j).data.std(:,i) = result(i).reactions(j).data.std(:,1);
                    end
                end
                for j = 1:length(this.inputs)
                    this.inputs(j).val(:,i) = result(i).inputs(j).val;
                    if ~isempty(this.inputs(j).data)
                        this.inputs(j).data.val(:,i) = result(i).inputs(j).data.val;
                        this.inputs(j).data.std(:,i) = result(i).inputs(j).data.std;
                    end
                end
            end
        end
    end
end