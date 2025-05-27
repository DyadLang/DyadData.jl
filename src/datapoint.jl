struct DyadDatapoint{T,S<:AbstractString}
    dataset::T
    variable_names::Vector{S}
end

"""
    DyadDatapoint(
    filepath::AbstractString = "";
    variable_names::Vector{<:AbstractString},
    kwargs...)

Represent a datapoint that is backed by a local file.

## Keyword arguments
- `variable_names`: a vector of the names of the columns for the variables

When reading files (local file option or a downloaded JuliaHub dataset), CSV.jl is used. Additional
keyword arguments passed to this function will be passed on to `CSV.read`.
This can help with changing settings such as the delimiter used in the file.
See https://csv.juliadata.org/stable/reading.html for more details.
"""
function DyadDatapoint(
    filepath::AbstractString;
    variable_names::Vector{<:AbstractString},
    kwargs...,
)
    dataset = FileDataset(filepath, kwargs)
    DyadDatapoint(dataset, variable_names)
end

"""
    DyadDatapoint(
    username::AbstractString,
    name::AbstractString;
    variable_names::Vector{<:AbstractString},
    kwargs...)

Represent a datapoint dataset that is backed by a JuliaHub dataset.

## Keyword arguments
- `variable_names`: a vector of the names of the columns for the variables

When reading files (local file option or a downloaded JuliaHub dataset), CSV.jl is used. Additional
keyword arguments passed to this function will be passed on to `CSV.read`.
This can help with changing settings such as the delimiter used in the file.
See https://csv.juliadata.org/stable/reading.html for more details.
"""
function DyadDatapoint(
    username::AbstractString,
    name::AbstractString;
    variable_names::Vector{<:AbstractString},
    kwargs...,
)
    dataset = JuliaHubDataset(username, name, tempname(), kwargs)
    DyadDatapoint(dataset, variable_names)
end

"""
    DyadDatapoint(
    data::AbstractVector;
    variable_names::Vector{<:AbstractString},
    kwargs...)

Represent a datapoint dataset that is backed by raw data (e.g. a vector).

## Keyword arguments
- `variable_names`: a vector of the names of the columns for the variables
"""
function DyadDatapoint(data::AbstractVector; variable_names::Vector{<:AbstractString})
    dataset = TabularDataset(variable_names .=> data)
    DyadDatapoint(dataset, variable_names)
end

function build_dataframe(d::DyadDatapoint)
    build_dataframe(d.dataset, d.variable_names)
end
