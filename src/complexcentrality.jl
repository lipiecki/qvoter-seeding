"""
    complexcentrality(g::SimpleGraph{<:Integer}, T::Vector{<:Integer}[, v::Integer])
Calculate the [complex centrality](https://doi.org/10.1038/s41467-021-24704-6) for graph `g` with threshold values specifified by vector `T`.

Return a vector of complex centralities calculated for each vertex.
If `v` is specified, calculate and return only the complex centrality of vertex `v`.
"""
function complexcentrality(g::SimpleGraph{<:Integer}, T::AbstractVector{<:Integer})
    centrality = zeros(nv(g))
    for v in vertices(g)
        centrality[v] = complexcentrality(g, T, v)
    end
    return centrality
end

function complexcentrality(g::SimpleGraph{<:Integer}, T::AbstractVector{<:Integer}, v::Integer)
    n = nv(g)
    seeds = unique(vcat([v], neighbors(g, v)))
    h = SimpleGraph(0)
    keys = zeros(Int, n)
    for w in seeds
        add_vertex!(h)
        keys[w] = nv(h)
    end
    for w in seeds
        for neighbor in neighbors(g, w)
            if neighbor in seeds
                add_edge!(h, keys[w], keys[neighbor])
            end
        end
    end
    active = falses(n)
    activated_now = falses(n)
    for w in seeds
        active[w] = true
    end
    complex_paths_len = 0.0
    diffused = false
    while !diffused
        diffused = true
        for w in vertices(g)
            if !active[w]
                c = sum(@view active[neighbors(g, w)])
                if c >= T[w]
                    diffused = false
                    active[w] = true
                    activated_now[w] = true
                    add_vertex!(h)
                    keys[w] = nv(h)
                end
            end
        end
        for w in vertices(g)
            if activated_now[w]
                for neighbor in neighbors(g, w)
                    if active[neighbor]
                        add_edge!(h, keys[w], keys[neighbor])
                    end
                end
            end
        end
        for w in vertices(g)
            if activated_now[w]
                complex_paths_len += length(a_star(h, 1, keys[w])) + 1
            end
            activated_now[w] = false
        end
    end
    return complex_paths_len/(n-length(seeds))
end

"""
    competitive_complexcentrality(g::SimpleGraph{<:Integer}, q::Integer[, v::Integer])
Calculate the [complex centrality](https://doi.org/10.1038/s41467-021-24704-6) for graph `g` with threshold values adjusted to `q`-voter dynamics, according to: ``T_w = \\max\\{q, \\lceil k_w/2\\rceil\\}``, where ``k_w`` is the degree of vertex ``w``.

Return a vector of complex centralities calculated for each vertex.
If `v` is specified, calculate and return only the complex centrality of vertex `v`.
"""
function competitive_complexcentrality(g::SimpleGraph{<:Integer}, q::Integer)
    T = zeros(Int, nv(g))
    for w in vertices(g)
        T[w] = max(min(q, degree(g, w)), Int(ceil(degree(g, w)/2)))
    end
    return complexcentrality(g, T)
end

function competitive_complexcentrality(g::SimpleGraph{<:Integer}, q::Integer, v::Integer)
    T = zeros(Int, nv(g))
    for w in vertices(g)
        T[w] = max(min(q, degree(g, w)), Int(ceil(degree(g, w)/2)))
    end
    return complexcentrality(g, T, v)
end
