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

function build_dataframe(dataset::FileDataset, column_names)
    path = abspath(dataset.path)
    isfile(path) || error("`$(path)` is not a valid file.")
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
