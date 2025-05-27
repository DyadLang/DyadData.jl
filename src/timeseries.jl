struct DyadDataset{T,S<:AbstractString}
    dataset::T
    independent_var::S
    dependent_vars::Vector{S}
end

"""
    DyadDataset(
    filepath::AbstractString = "";
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
    kwargs...)

Represent a timeseries-like dataset that is backed by a local file.

## Keyword arguments
- `independent_var`: the name of the column that represents the independent variable (usually the time)
- `dependent_vars`: a vector of the names of the columns for the dependent variables

When reading files (local file option or a downloaded JuliaHub dataset), CSV.jl is used. Additional
keyword arguments passed to this function will be passed on to `CSV.read`.
This can help with changing settings such as the delimiter used in the file.
See https://csv.juliadata.org/stable/reading.html for more details.
"""
function DyadDataset(
    filepath::AbstractString;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
    kwargs...,
)
    dataset = FileDataset(filepath, kwargs)
    DyadDataset(dataset, independent_var, dependent_vars)
end

"""
    DyadDataset(
    username::AbstractString,
    name::AbstractString;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
    kwargs...)

Represent a timeseries-like dataset that is backed by a JuliaHub dataset.

## Keyword arguments
- `independent_var`: the name of the column that represents the independent variable (usually the time)
- `dependent_vars`: a vector of the names of the columns for the dependent variables

When reading files (local file option or a downloaded JuliaHub dataset), CSV.jl is used. Additional
keyword arguments passed to this function will be passed on to `CSV.read`.
This can help with changing settings such as the delimiter used in the file.
See https://csv.juliadata.org/stable/reading.html for more details.
"""
function DyadDataset(
    username::AbstractString,
    name::AbstractString;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
    kwargs...,
)
    dataset = JuliaHubDataset(username, name, tempname(), kwargs)
    DyadDataset(dataset, independent_var, dependent_vars)
end

"""
    DyadDataset(
    data;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
    kwargs...)

Represent a timeseries-like dataset that is backed by raw data.

## Keyword arguments
- `independent_var`: the name of the column that represents the independent variable (usually the time)
- `dependent_vars`: a vector of the names of the columns for the dependent variables
"""
function DyadDataset(
    data;
    independent_var::AbstractString,
    dependent_vars::Vector{<:AbstractString},
)
    dataset = TabularDataset(data)
    DyadDataset(dataset, independent_var, dependent_vars)
end

"""
    build_dataframe(d::DyadDataset)

Build a `DataFrame` out of the specified timeseries dataset. The column names will correspond
to the names of the independent variable & the ones for the dependent variables.
Note that the order of the columns is dictated by the order in the file, not by the order
inside the `dependent_vars` argument for [`DyadDataset`](@ref).
The `dependent_vars` argument only specifies the available columns to use, not their order.
"""
function build_dataframe(d::DyadDataset)
    build_dataframe(d.dataset, vcat(d.independent_var, d.dependent_vars))
end
