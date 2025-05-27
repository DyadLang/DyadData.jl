using DyadData
using Test
using Aqua
using JET
using DataFrames

@testset verbose = true "DyadData.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(DyadData)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(DyadData; target_defined_modules = true)
    end

    @testset "DyadDataset" begin
        d1 = DyadDataset(
            joinpath(@__DIR__, "lotka.csv");
            independent_var = "timestamp",
            dependent_vars = ["y(t)", "x(t)"],
        )
        df = build_dataframe(d1)
        # note that the order of the columns is the one in the file
        # the dependent_vars argument
        @test names(df) == ["timestamp", "x(t)", "y(t)"]
        @test length(df.timestamp) == 21
        @test eltype(df."x(t)") == Float64

        d2 = DyadDataset(
            "juliasimtutorials",
            "circuit_data";
            independent_var = "timestamp",
            dependent_vars = ["ampermeter.i(t)"],
        )
        df = build_dataframe(d2)
        @test names(df) == ["timestamp", "ampermeter.i(t)"]
        @test length(df.timestamp) == 100
        @test eltype(df."ampermeter.i(t)") == Float64

        d3 = DyadDataset(rand(4, 3); independent_var = "t", dependent_vars = ["a", "b"])
        df = build_dataframe(d3)
        @test names(df) == ["t", "a", "b"]
        @test length(df.t) == 4
        @test eltype(df."a") == Float64
    end

    @testset "DyadDatapoint" begin
        d1 = DyadDatapoint(
            joinpath(@__DIR__, "reaction_system_data_end.csv");
            variable_names = ["s1(t)", "s1s2(t)", "s2(t)"],
        )
        df = build_dataframe(d1)
        @test names(df) == ["s1(t)", "s1s2(t)", "s2(t)"]
        @test length(df."s1(t)") == 1
        @test eltype(df."s1s2(t)") == Float64

        d2 = DyadDatapoint(
            "juliasimtutorials",
            "reaction_system_data_end";
            variable_names = ["s1(t)", "s1s2(t)", "s2(t)"],
        )
        df = build_dataframe(d2)
        @test names(df) == ["s1(t)", "s1s2(t)", "s2(t)"]
        @test length(df."s1(t)") == 1
        @test eltype(df."s1(t)") == Float64

        d3 = DyadDatapoint(rand(2); variable_names = ["a", "b"])
        df = build_dataframe(d3)
        @test names(df) == ["a", "b"]
        @test length(df.a) == 1
        @test eltype(df."a") == Float64
    end
end
