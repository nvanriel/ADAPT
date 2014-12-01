classdef DataSet < handle
    properties
        name
        description
        specification
        
        data
        
        groups
        activeGroup
        
        fields
        functions
        ref
        list
        
        funcs
        compileDir
    end
    methods
        function this = DataSet(dataFile)
            this.name = dataFile;
            this.specification = feval(dataFile);
            this.description = this.specification.DESCRIPTION;
            this.groups = this.specification.GROUPS;
            
            this.compileDir = 'temp/';
            this.funcs.func = str2func(['C_', this.name, '_FUNCTIONS']);
            
            % fields
            this.fields = AMF.DataField.empty;
            n = size(this.specification.FIELDS, 1);
            for i = 1:n
                fieldSpec = this.specification.FIELDS(i,:);
                fieldName = fieldSpec{1};
                newField = AMF.DataField(i, fieldSpec{:});
                this.ref.(fieldName) = newField;
                
                this.fields(i) = newField;
            end
            
            % functions
            if isfield(this.specification, 'FUNCTIONS')
                this.functions = AMF.DataFunction.empty;
                m = size(this.specification.FUNCTIONS, 1);
                for i = 1:m
                    fieldSpec = this.specification.FUNCTIONS(i,:);
                    fieldName = fieldSpec{1};
                    newFunc = AMF.DataFunction(i + n, fieldSpec{:});
                    this.ref.(fieldName) = newFunc;

                    this.functions(i) = newFunc;
                end
            end
            
%             this.fields = struct2array(this.ref);
            this.list = struct2cell(this.ref);
            
            this.data = load([this.specification.FILE, '.mat']);
            
            this.loadGroup(this.groups{1});
            
            if ~isempty(this.functions)
                compileFunctions(this);
            end
        end
    end
end