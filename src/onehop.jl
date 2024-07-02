"""
    onehop(g::SimpleGraph{<:Integer}, seedsize::Integer)
Construct a seed set of size `seedsize` on graph `g` using one-hop strategy.

Return a vector of seed vertices.
"""
function onehop(g::SimpleGraph{<:Integer}, seedsize::Integer)
    initialsample = sample(vertices(g), seedsize, replace = false)
    seed = (v -> rand(neighbors(g, v))).(initialsample)
    unique!(sort!(seed))
    if length(seed) < seedsize
        filter!(v -> v ∉ seed, initialsample)
        append!(seed, sample(initialsample, seedsize - length(seed), replace = false))
    end
    return seed
end
