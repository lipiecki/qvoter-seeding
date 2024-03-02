include("src/simexperiment.jl")

if lastindex(ARGS) == 3
    simexperiment(ARGS[1], parse(Bool, ARGS[2]), parse(Int, ARGS[3]))
elseif lastindex(ARGS) == 4
    simexperiment(ARGS[1], parse(Bool, ARGS[2]), parse(Int, ARGS[3]), id = parse(Int, ARGS[4]))
else
    error("incorrect number of arguments")
end