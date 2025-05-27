using DyadData
using Documenter

DocMeta.setdocmeta!(DyadData, :DocTestSetup, :(using DyadData); recursive = true)

makedocs(;
    modules = [DyadData],
    authors = "JuliaHub",
    sitename = "DyadData.jl",
    format = Documenter.HTML(;
        canonical = "https://JuliaComputing.github.io/DyadData.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/JuliaComputing/DyadData.jl", devbranch = "main")
