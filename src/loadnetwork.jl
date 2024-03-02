using Graphs, Random, DelimitedFiles

function loadnetwork(network::String, rng_seed::Union{Nothing, Integer} = nothing)
    if network == "snap"
        srcfile = "networks/facebook_combined.txt"
        separator = ' '
    elseif network == "politician"
        srcfile = "networks/fb-pages-politician.edges"
        separator = ','
    else
        error("unknown network")
    end
    edges = readdlm(srcfile, separator, Int, '\n')
    rows = size(edges)[1]
    nodes = maximum(edges) + 1
    graph = SimpleGraph(nodes)
    for row in 1:rows
        add_edge!(graph, edges[row, 1]+1, edges[row, 2]+1)
    end
    rng = isnothing(rng_seed) ? Xoshiro() : Xoshiro(rng_seed)
    for vertex in vertices(graph)
        if degree(graph, vertex) == 1
            neighborhood = filter(v -> v != vertex, neighbors(graph, neighbors(graph, vertex)[1]))
            add_edge!(graph, vertex, rand(rng, neighborhood))
        end
    end
    return graph
end