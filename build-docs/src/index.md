# QVoterSeeding.jl

**Julia package for network seeding simulations under q-voter dynamics**

## Citing
This package is supplementary to the [paper](https://doi.org/10.1007/978-3-031-63759-9_8) I presented at ICCS 2024, if you find it useful in your research, please consider adding the following citation:

```bibtex
@inproceedings{lipiecki2024,
    author = {Lipiecki, Arkadiusz},
    year = {2024},
    title = {Strategic Promotional Campaigns for Sustainable Behaviors: Maximizing Influence in Competitive Complex Contagions},
    editor = {Franco, Leonardo
              and de Mulatier, Cl{\'e}lia
              and Paszynski, Maciej
              and Krzhizhanovskaya, Valeria V.
              and Dongarra, Jack J.
              and Sloot, Peter M. A.},
    booktitle = {Computational Science -- ICCS 2024},
    publisher = {Springer Nature Switzerland},
    address = {Cham},
    pages = {62--70},
    isbn = {978-3-031-63759-9},
    doi = {https://doi.org/10.1007/978-3-031-63759-9_8}
}
```

## Installation
To install the package, use the following lines in Julia REPL:

```julia
julia> using Pkg
julia> Pkg.add(url = "https://github.com/lipiecki/QVoterSeeding.jl")
```

## Datasets
The following network datasets are provided with the package:
- [SNAP Facebook Network](https://snap.stanford.edu/data/ego-Facebook.html)
- [GEMSEC Facebook Page Network of Politicians](https://snap.stanford.edu/data/gemsec-Facebook.html)

## Example
This code snippet performs network seeding experiments on the SNAP Facebook network using the one-hop seeding strategy within the 2-voter model with zealot (infelxible) seeds:

```julia
using QVoterSeeding

network = :snap
strategy = :onehop
zealots = true
q = 2
budgets = 0.025:0.025:0.5

results = seeding(network, strategy, zealots, q, budgets)
```
`results` is a vector of final concentrations of active nodes obtained for each seeding budget
