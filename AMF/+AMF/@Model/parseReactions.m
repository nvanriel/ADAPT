function this = parseReactions(this)

for comp = this.reactions
    comp.time = this.predictor.val;
    comp.val = zeros(size(comp.time));
end