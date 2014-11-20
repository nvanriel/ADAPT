function this = parseAll(this)

parseConstants(this);
parseInputs(this);
parseStates(this);
parseReactions(this);
parseParameters(this);

this.observables = filter(this, @isObservable);
this.mStruct = getInputStructMex(this);


this.result.p = [];
this.result.x = [];
this.result.u = [];
this.result.v = [];