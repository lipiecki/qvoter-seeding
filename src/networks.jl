"""
    loadnetwork(networkname::Symbol, rng::AbstractRNG = Random.default_rng(); preprocess::Bool = true)
Load network data from the `networks` directory or from the specified filepath.

Available options for `network`:
- `:snap` for SNAP Facebook network
- `:politicians` for GEMSEC Facebook page network of politicians
- `"..."` for network at filepath `"..."`; the file is assumed to be an edge list in a CSV format with node indexing starting from 0.

Optional argument `rng` specifies a random number generator used for preprocessing of the network data.
Keyword argument `preprocess` specifies whether to perform preprocessing ([`prune!`](@ref) and [`addneighbors!`](@ref)).

Return a graph representing the selected network.
"""
function loadnetwork(networkname::Symbol, rng::AbstractRNG = Random.default_rng(); preprocess::Bool = true)
    if networkname == :snap
        return loadnetwork(joinpath(@__DIR__, "..", "data", "snap_edges.csv"), rng, preprocess = preprocess)
    elseif networkname == :politicians
        return loadnetwork(joinpath(@__DIR__, "..", "data", "politicians_edges.csv"), rng, preprocess = preprocess)
    end
    error("unknown network")
end

function loadnetwork(networkpath::String, rng::AbstractRNG = Random.default_rng(); preprocess::Bool = true)
    edges = readdlm(networkpath, ',', Int, '\n')
    rows = size(edges)[1]
    nodes = maximum(edges) + 1
    g = SimpleGraph(nodes)
    for row in 1:rows
        add_edge!(g, edges[row, 1]+1, edges[row, 2]+1)
    end
    if preprocess
        prune!(g)
        addneighbors!(g, rng)
    end
    return g
end

"""
    average_clustering(network::Union{Symbol, String}, m::Integer, rng::AbstractRNG = Random.default_rng())
Calculate the average clustering coefficient of a raw network and an ensemble of `m` preprocessed networks.

Available options for `network`:
- `:snap` for SNAP Facebook network
- `:politicians` for GEMSEC Facebook page network of politicians
- `"..."` for network file at path `"..."`.

Optional argument `rng` specifies a random number generator used for generating an ensemble of preprocessed networks.

Return a tuple of the average clustering coefficient for a raw network and for a network ensemble.
"""
function average_clustering(network::Union{Symbol, String}, m::Integer, rng::AbstractRNG = Random.default_rng())
    δ₀, δ = 0.0, 0.0
    g = loadnetwork(network, preprocess = false)
    δ₀ = sum(local_clustering_coefficient(g))/nv(g)
    for _ in 1:m
        g = loadnetwork(network, rng)
        δ = sum(local_clustering_coefficient(g))/nv(g)
    end
    return δ₀, δ/m
end

"""
    average_degree(network::Union{Symbol, String}, m::Integer, rng::AbstractRNG = Random.default_rng())
Calculate the average node degree of a raw network and an ensemble of `m` preprocessed networks.

Available options for `network`:
- `:snap` for SNAP Facebook network
- `:politicians` for GEMSEC Facebook page network of politicians
- `"..."` for network file at path `"..."`.

Optional argument `rng` specifies a random number generator used for generating an ensemble of preprocessed networks.

Return a tuple of the average node degree for a raw network and for a network ensemble.
"""
function average_degree(network::Union{Symbol, String}, m::Integer, rng::AbstractRNG = Random.default_rng())
    k₀, k = 0.0, 0.0
    g = loadnetwork(network, preprocess = false)
    k₀ = sum(degree(g))/nv(g)
    for _ in 1:m
        g = loadnetwork(network, rng)
        k = sum(degree(g))/nv(g)
    end
    return k₀, k/m
end

"""
    average_pathlen(network::Union{Symbol, String}, m::Integer, rng::AbstractRNG = Random.default_rng())
Calculate the average shortest path length of a raw network and an ensemble of `m` preprocessed networks.

Available options for `network`:
- `:snap` for SNAP Facebook network
- `:politicians` for GEMSEC Facebook page network of politicians
- `"..."` for network file at path `"..."`.

Optional argument `rng` specifies a random number generator used for generating an ensemble of preprocessed networks.

Return a tuple of the average shortest path length for a raw network and for a network ensemble.
"""
function average_pathlen(network::Union{Symbol, String}, m::Integer, rng::AbstractRNG = Random.default_rng())
    D₀, D = 0.0, 0.0
    g = loadnetwork(network, preprocess = false)
    for v in vertices(g)
        D₀ += sum(dijkstra_shortest_paths(g, v).dists)
    end
    D₀ /= nv(g)*(nv(g)-1)
    for _ in 1:m
        g = loadnetwork(network, rng)
        d = 0.0
        for v in vertices(g)
            d += sum(dijkstra_shortest_paths(g, v).dists)
        end
        D += d/(nv(g)*(nv(g)-1))
    end
    return D₀, D/m
end

"""
    prune!(g::SimpleGraph{<:Integer})
Modify graph `g` by removing self-loops and isolated vertices.
"""
function prune!(g::SimpleGraph{<:Integer})
    pruned = false
    while !pruned
        pruned = true
        for v in vertices(g)
            rem_edge!(g, v, v)
            if degree(g, v) == 0  
                rem_vertex!(g, v)
                pruned = false
            end
        end
    end
end

"""
    addneighbors!(g::SimpleGraph{<:Integer}, rng::AbstractRNG = Random.default_rng())
Modify graph `g` by adding a new neighbor to every single-neighbor-vertex via triad formation.

Optional argument `rng` specifies a random number generator.
"""
function addneighbors!(g::SimpleGraph{<:Integer}, rng::AbstractRNG = Random.default_rng())
    for v in vertices(g)
        if degree(g, v) == 1
            neighborhood = filter(w -> w != v, neighbors(g, neighbors(g, v)[1]))
            add_edge!(g, v, rand(rng, neighborhood))
        end
    end
end
