using Graphs, StatsBase

function qvoter(graph::SimpleGraph, active::BitVector, q::Integer, flexible::Bool, timespan::Integer = 10^5, average_period::Integer = 10^3)
    n = nv(graph)
    c = sum(active)
    qpanel = Vector{Int}(undef, q)
    dynamic_nodes = flexible ? collect(1:n) : filter(v -> !active[v], 1:n)
    for t in 1:timespan
        for i in 1:n
            vertex = rand(dynamic_nodes)
            if degree(graph, vertex) <= q
                influence = sum(@view active[neighbors(graph, vertex)])
                if !active[vertex] && influence == degree(graph, vertex)
                    active[vertex] = true
                    c += 1
                elseif active[vertex] && influence == 0
                    active[vertex] = false
                    c -= 1
                end
            else
                sample!(neighbors(graph, vertex), qpanel, replace = false)
                influence = sum(@view active[qpanel])
                if !active[vertex] && influence == q
                    active[vertex] = true
                    c += 1
                elseif active[vertex] && influence == 0
                    active[vertex] = false
                    c -= 1
                end
            end
        end
        if c == n || c == 0
            return c/n
        end
    end
    average_c = 0
    for t in 1:average_period
        for i in 1:n
            vertex = rand(dynamic_nodes)
            if degree(graph, vertex) <= q
                influence = sum(@view active[neighbors(graph, vertex)])
                if !active[vertex] && influence == degree(graph, vertex)
                    active[vertex] = true
                    c += 1
                elseif active[vertex] && influence == 0
                    active[vertex] = false
                    c -= 1
                end
            else
                sample!(neighbors(graph, vertex), qpanel, replace = false)
                influence = sum(@view active[qpanel])
                if !active[vertex] && influence == q
                    active[vertex] = true
                    c += 1
                elseif active[vertex] && influence == 0
                    active[vertex] = false
                    c -= 1
                end
            end
        end
        if c == n || c == 0
            return c/n
        else
            average_c += c/n
        end
    end
    return average_c/average_period
end