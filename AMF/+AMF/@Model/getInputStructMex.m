function mStruct = getInputStructMex(this)

for state = this.states, mStruct.s.(state.name) = state.index; end
for param = this.parameters, mStruct.p.(param.name) = param.index; end
for constant = this.constants, mStruct.c.(constant.name) = constant.val; end

% TODO: fix allocation
n = 1;
for input = this.inputs
    mStruct.u.(input.name) = n:n+length(input.initVal)-1;
    n = n+length(input.initVal);
    mStruct.u.([input.name, '_t']) = n:n+length(input.initTime)-1;
    n = n+length(input.initTime);
end
