# QVoterSeeding.jl
[![Static Badge](https://img.shields.io/badge/view-documentation-royalblue)](https://lipiecki.github.io/QVoterSeeding.jl/)
[![Static Badge](https://img.shields.io/badge/view-paper-mediumpurple)](https://doi.org/10.1007/978-3-031-63759-9_8)
[![Static Badge](https://img.shields.io/badge/view-preprint-forestgreen)](https://www.iccs-meeting.org/archive/iccs2024/papers/148340057.pdf)

**Julia package for network seeding simulations under q-voter dynamics**

## Table of Contents
1. [Citing](#citing)
2. [Installation](#installation)
3. [Features](#features)
4. [Datasets](#datasets)
5. [Example](#example)
6. [Documentation](#documentation)

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

## Features

### Q-Voter Model
Run Monte Carlo simulations of the [q-voter model](https://doi.org/10.1103/PhysRevE.80.041129) on undirected graphs, with specified intial conditions and flexibility of agents

### Seeding
Conduct network seeding experiments within the q-voter model using one of the selected strategies:
- high degree
- PageRank
- complex centrality
- one-hop
- random

### Networks
Load and prepreprocess network data, calculate statistics of networks and network ensembles

### Complex Centrality
Calculate the [complex centrality](https://doi.org/10.1038/s41467-021-24704-6) of vertices in a given graph

### One-hop
Select seed nodes from a given graph via the one-hop seeding strategy

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

## Documentation
See full [documentation](https://lipiecki.github.io/QVoterSeeding.jl/) for more details
