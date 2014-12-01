function mStruct = getInputStruct(this)

for state = this.states, mStruct.s.(state.name) = state.index; end
for param = this.parameters, mStruct.p.(param.name) = param.index; end
for constant = this.constants, mStruct.c.(constant.name) = constant.val; end
for reaction = this.reactions, mStruct.v.(reaction.name) = reaction.index; end
for input = this.inputs, mStruct.u.(input.name) = input.index; end
