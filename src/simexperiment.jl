using JLD2
include("complexcentrality.jl")
include("loadnetwork.jl")
include("qvoter.jl")
include("seeding.jl")

function simexperiment(networkname::String, flexible::Bool, q::Integer; budgets::Vector{<:Real} = collect(0.025:0.025:0.6), strategies::Vector{String} = ["hd", "pr", "cc", "one-hop", "random"], id::Union{Nothing, Integer} = nothing)
    for strategy in strategies
        strategy ∈ ["hd", "pr", "cc", "one-hop", "random"] || error("unknown strategy")
    end
    network = loadnetwork(networkname, id)
    networksize = nv(network)
    rankhd = "hd" ∈ strategies ? sortperm(degree(network), rev = true) : nothing
    rankpr = "pr" ∈ strategies ? sortperm(pagerank(network, 0.85), rev = true) : nothing
    rankcc = "cc" ∈ strategies ? sortperm(qvoter_complexcentrality(network, q), rev = true) : nothing
    results = zeros(length(budgets), length(strategies))
    active = falses(networksize)
    for b in eachindex(budgets)
        seedsize = Int(ceil(budgets[b]*networksize))
        for s in eachindex(strategies)
            fill!(active, false)
            if strategies[s] == "hd"
                for i in 1:seedsize
                    active[rankhd[i]] = true
                end
            elseif strategies[s] == "pr"
                for i in 1:seedsize
                    active[rankpr[i]] = true
                end
            elseif strategies[s] == "cc"
                for v in clusteredseeding(network, rankcc, seedsize)
                    active[v] = true
                end
            elseif strategies[s] == "one-hop"
                for v in onehop(network, seedsize)
                    active[v] = true
                end
            elseif strategies[s] == "random"
                for v in sample(1:networksize, seedsize, replace = false)
                    active[v] = true
                end
            end
            results[b, s] = qvoter(network, active, q, flexible)
        end
    end
    save("outputs/$(networkname)_$(q)_$(flexible ? "flexible" : "inflexible")$(isnothing(id) ? ".jld2" : "_$(id).jld2")", "results", results, "budgets", budgets, "strategies", strategies)
end