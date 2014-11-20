function val = parseFunctions(this)

for dataFunc = this.functions
    stdComp = this.ref.(dataFunc.stdDataField);
    
    dataFunc.time = stdComp.time;
    dataFunc.src.time = stdComp.src.time;

    dataFunc.std = stdComp.std;
    dataFunc.curr.std = stdComp.curr.std;
    dataFunc.src.std = stdComp.src.std;
    
    val = [];
    currVal = [];
    srcVal = [];
    for i = 1:length(dataFunc.args)
        compName = dataFunc.args{i};
        comp = this.ref.(compName);
        
        val(i,:) = comp.val;
        currVal(i,:) = comp.curr.val;
        srcVal(i,:) = comp.src.val;
    end
    
    dataFunc.val = dataFunc.func(val)';
    dataFunc.curr.val = dataFunc.func(currVal);
    dataFunc.src.val = dataFunc.func(srcVal);
end