using Documenter, QVoterSeeding

makedocs(
    sitename = "QVoterSeeding.jl",
    build  = joinpath("..", "docs"), 
    format = Documenter.HTML(
        repolink = "https://github.com/lipiecki/QVoterSeeding.jl",
        inventory_version = ""),
    pages = ["Home" => "index.md",
             "Functions" => "functions.md"])
