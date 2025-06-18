module DyadData

using DataFrames: DataFrame
using CSV: CSV
using JuliaHub: download_dataset

export DyadDataset, DyadDatapoint, build_dataframe

struct FileDataset{T<:AbstractString,O}
    path::T
    read_options::O
end

struct JuliaHubDataset{T<:AbstractString,O}
    username::T
    name::T
    download_path::String
    read_options::O
end

struct TabularDataset{T}
    data::T
end

include("timeseries.jl")
include("datapoint.jl")

"""
    resolve_dyad_uri(uri::AbstractString)

Resolve a `dyad://` URI to a local file path.

The expected scheme is `dyad://s<package_name>/<local_path>`,
relative to the package root.

## Examples
```julia
julia> using BlockComponents, DyadData

julia> DyadData.resolve_dyad_uri("dyad://BlockComponents/data/block_components.csv")
"/Users/someuser/.julia/dev/BlockComponents/data/block_components.csv"
```
"""
function resolve_dyad_uri(uri::AbstractString)
    # All dyad:// urls must have '/' as the path separator
    @assert startswith(uri, "dyad://") "Malformed Dyad URI (does not start with `dyad://`): $(uri)"
    parts = split(uri, '/')
    @assert length(parts) > 4 "Malformed Dyad URI (too few parts): $(uri)"
    package_name = parts[3]
    local_path = joinpath(parts[4:end])
    # Find the package's path using `Base.find_package`.
    # Note it does not accept substrings, so we need to construct a string again.
    package_mainfile_path = Base.find_package(string(package_name))
    isnothing(package_mainfile_path) && error("""
    When resolving `dyad://` URI, could not find package `$(package_name)`.\n
    Full URI was `$(uri)`.

    It could be that your Julia environment was not properly instantiated,
    or it does not contain the package `$(package_name)`.

    To fix this, you can try running `using Pkg; Pkg.instantiate()` to instantiate your environment,
    or `using Pkg; Pkg.add("$(package_name)")` to add the package to your environment.
    """)
    # That is the path to the main file of the package (root/src/PackageName.jl)
    # so we have to go up two levels to get to the package root.
    package_path = dirname(dirname(package_mainfile_path))
    @assert isdir(package_path)

    return joinpath(package_path, local_path)
end

function build_dataframe(dataset::FileDataset, column_names)
    path = if startswith(dataset.path, "dyad://")
        resolve_dyad_uri(dataset.path)
    else
        abspath(dataset.path)
    end
    @assert isfile(path) "`$(path)` is not a valid file."
    select = Symbol.(column_names)
    return CSV.read(path, DataFrame; header = 1, select, dataset.read_options...)
end

function build_dataframe(dataset::JuliaHubDataset, column_names)
    path = dataset.download_path
    download_dataset((dataset.username, dataset.name), path, quiet = true, replace = true)

    build_dataframe(FileDataset(path, dataset.read_options), column_names)
end

function build_dataframe(dataset::TabularDataset, column_names)
    DataFrame(dataset.data, column_names)
end

end # module DyadData
