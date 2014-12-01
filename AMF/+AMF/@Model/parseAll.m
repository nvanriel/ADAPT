function this = parseAll(this)

parseConstants(this);
parseStates(this);
parseReactions(this);
parseParameters(this);
parseInputs(this);

this.iStruct = getInputStruct(this);
this.mStruct = getInputStructMex(this);