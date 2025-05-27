# DyadData

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaComputing.github.io/DyadData.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaComputing.github.io/DyadData.jl/dev/)
[![Build Status](https://github.com/JuliaComputing/DyadData.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaComputing/DyadData.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

DyadData provides an interface (`DyadDataset`) for timeseries-like datasets in dyad. The datasets can be represented by local files, JuliaHub.jl datasets or raw data.

## API

For local files

```julia
DyadDataset(
    filepath::AbstractString;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
    kwargs...,
)
```

For JuliaHub datasets

```julia
DyadDataset(
    username::AbstractString,
    name::AbstractString;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
    kwargs...,
)
```

For raw data

```julia
DyadDataset(
    data;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
)
```

To work with the data, the `build_dataframe(::DyadDataset)` can be used to get a `DataFrame`, as the name implies.
In the case of file based datasets, this will open the file with CSV.jl and in the case of JuliaHub datastes,
this will download the dataset and then open it.
To pass read options for CSV.jl, additional keyword arguments can be passed to `DyadDataset` and they will be
forwarded to `CSV.read`.
