using Graphs, StatsBase

function onehop(graph::SimpleGraph{Int64}, seedsize::Integer)
    firstround = sample(vertices(graph), seedsize, replace = false)
    seed = unique([rand(neighbors(graph, vertex)) for vertex in firstround])
    deficit = seedsize - length(seed)
    if deficit > 0
        filter!(v -> v ∉ seed, firstround)
        seed = vcat(seed, sample(firstround, deficit, replace = false))
    end
    return seed
end

function clusteredseeding(graph::SimpleGraph{Int64}, ranked::Vector{Int64}, seedsize::Integer)
    seeds = zeros(Int, seedsize)
    iter = 0
    counter = 0
    while counter < seedsize    
        iter += 1
        counter += 1
        while ranked[iter] in seeds
            iter += 1
        end
        seeds[counter] = ranked[iter]
        if counter < seedsize
            cluster = neighbors(graph, seeds[counter])
            if length(cluster) <= seedsize - counter
                for v in cluster
                    if v ∉ seeds
                        counter += 1
                        seeds[counter] = v
                    end
                end
            else
                sort!(cluster, by = x -> ranked[x])
                for v in cluster
                    if v ∉ seeds
                        counter += 1
                        seeds[counter] = v
                        if counter == seedsize
                            return seeds
                        end
                    end
                end
            end
        end
    end
    return seeds
end