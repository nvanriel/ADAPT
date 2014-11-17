function u = getInputsMex(this)

u = [];
for input = this.inputs
    u = [u, input.initVal(:)', input.initTime(:)'];
end