using Graphs

function qvoter_complexcentrality(graph::SimpleGraph{Int64}, q::Integer, target::Int64)
    n = nv(graph)
    T = zeros(Int, n)
    for vertex in vertices(graph) 
        T[vertex] = max(min(q, degree(graph, vertex)), Int(ceil(degree(graph, vertex)/2)))
    end
    neighborhood = neighbors(graph, target)
    seeds = vcat([target], neighborhood)
    keys = Int.(zeros(n))
    invkeys = Int.(zeros(n))
    induced_subgraph = SimpleGraph(1)
    keys[target] = 1
    invkeys[1] = target
    iter = 2
    for vertex in neighborhood
        add_vertex!(induced_subgraph)
        keys[vertex] = iter
        invkeys[iter] = vertex
        iter += 1
    end
    for vertex in seeds
        for neighbor in neighbors(graph, vertex)
            if neighbor in seeds
                add_edge!(induced_subgraph, keys[vertex], keys[neighbor])
            end
        end
    end
    active = falses(n)
    new_active = falses(n)
    for v in seeds
        active[v] = true
    end
    average_length = 0.0
    diffused = false
    while !diffused
        diffused = true
        for vertex in vertices(graph)
            if !active[vertex]
                c = sum(@view active[neighbors(graph, vertex)])
                if c >= T[vertex]
                    diffused = false
                    active[vertex] = true
                    new_active[vertex] = true
                    add_vertex!(induced_subgraph)
                    keys[vertex] = iter
                    invkeys[iter] = vertex
                    iter += 1
                end
            end
        end
        for vertex in vertices(graph)
            if new_active[vertex]
                for neighbor in neighbors(graph, vertex)
                    if active[neighbor]
                        add_edge!(induced_subgraph, keys[vertex], keys[neighbor])
                    end
                end
            end
        end
        for vertex in vertices(graph)
            if new_active[vertex]
                l = length(a_star(induced_subgraph, 1, keys[vertex])) 
                if l != 0
                    average_length += l + 1
                end
            end
            new_active[vertex] = false
        end
    end
    return average_length/(n-length(seeds))
end

function qvoter_complexcentrality(graph::SimpleGraph{Int64}, q::Integer)
    centrality = zeros(nv(graph))
    for vertex in vertices(graph)
        centrality[vertex] = qvoter_complexcentrality(graph, q, vertex)
    end
    return centrality
end