classdef Model < handle
    properties
        name
        specification
        dataset
        
        compilePrefix
        compileDir
        resultsDir
        
        functions
        
        template
        list
        ref
        
        predictors
        constants
        inputs
        parameters
        states
        reactions
        
        fitParameters
        observableStates
        observableReactions
        observables
        mStruct

        predictor
        
        time
        fitTime
        
        options
        result
        
        currTimeStep
    end
    methods
        function this = Model(modelFile)
            this.name = modelFile;
            this.specification = feval(modelFile);

            this.compileDir = 'temp/';
            this.compilePrefix = ['C_', this.name];
            
            if ~exist(this.compileDir, 'dir')
                mkdir(this.compileDir);
            end
            addpath(this.compileDir);
            
            this.resultsDir = 'results/';
            
            if ~exist(this.resultsDir, 'dir')
                mkdir(this.resultsDir);
            end
            addpath(this.resultsDir);
            
            this.functions.ODE = str2func([this.compilePrefix, '_ODE']);
            this.functions.ODEMex = str2func([this.compilePrefix, '_ODEMEX']);
            this.functions.ODEC = str2func([this.compilePrefix, '_ODEC']);
            this.functions.reactions = str2func([this.compilePrefix, '_REACTIONS']);
            this.functions.inputs = str2func([this.compilePrefix, '_INPUTS']);
            this.functions.reg = [];
            this.functions.err = @AMF.errFun;
            this.functions.errStep = @AMF.errFunStep;

            addComponents(this, 'PREDICTOR', this.specification, @AMF.ModelPredictor);
            addComponents(this, 'CONSTANTS', this.specification, @AMF.ModelConstant);
            addComponents(this, 'INPUTS', this.specification, @AMF.ModelInput);
            addComponents(this, 'PARAMETERS', this.specification, @AMF.ModelParameter);
            addComponents(this, 'STATES', this.specification, @AMF.ModelState);
            addComponents(this, 'REACTIONS', this.specification, @AMF.ModelReaction);
            
            % component list
            this.list = struct2cell(this.ref);
            
            % component groups
            this.predictor = getAll(this, 'predictor');
            this.constants = getAll(this, 'constants');
            this.inputs = getAll(this, 'inputs');
            this.parameters = getAll(this, 'parameters');
            this.states = getAll(this, 'states');
            this.reactions = getAll(this, 'reactions');
            
            % derived component groups
            this.fitParameters = filter(this.parameters, @isFitParameter);
            
            % ---
            
            % default options
            this.options.optimset  = optimset('MaxIter',1e3,'Display','off','MaxFunEvals',1e5,'TolX',1e-8,'TolFun',1e-8);
            this.options.odeTol    = [1e-12 1e-12 100];
            this.options.useMex    = 0;
            % TODO: odeset
            this.options.parScale  = [2 -2];
            this.options.numIter   = 1;
            this.options.lab1      = .1;
            this.options.seed      = 1;
            this.options.numTimeSteps = this.predictor.val(end) - this.predictor.val(1);
            this.options.SSTime    = 1000;
            this.options.savePrefix = '';
            
            this.options.interpMethod = 'linear';
            
            this.currTimeStep = 0;

            this.time = getTime(this);
        end
    end
end