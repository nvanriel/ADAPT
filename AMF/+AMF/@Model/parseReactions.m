function this = parseReactions(this)

for comp = this.reactions
    comp.time = this.time(:);
    comp.val = zeros(size(comp.time));
end