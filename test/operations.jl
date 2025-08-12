using LinearAlgebra

@testset "operations" begin

    hv_types = [BinaryHV, BipolarHV, RealHV, TernaryHV,
                GradedHV, GradedBipolarHV]

    N = 500

    for HV in hv_types
        @testset "operations $HV" begin

            hv1 = HV(N)
            hv2 = HV(N)

            v1 = collect(hv1)
            v2 = collect(hv2)

            @testset "aggregate $HV" begin
                @test aggregate((hv1, hv2)) isa HV
                @test aggregate([hv1, hv2]) isa HV
                @test aggregate((HV(N) for i in 1:5)) isa HV
                @test hv1 + hv2 isa HV
            end

            @testset "bind $HV" begin
                @test bind(hv1, hv2) isa HV
                @test hv1 * hv2 isa HV
            end

            @testset "shift $HV" begin
                @test shift(hv1, 3) ≈ circshift(v1, 3)
                @test shift!(hv2, -8) ≈ circshift(v2, -8)
                @test ρ(hv1, 2) ≈ circshift(v1, 2)
            end

            # currently not yet a good way of evaluating these
            HV <: Union{TernaryHV,GradedHV,GradedBipolarHV,RealHV} && continue

            @testset "similarity $HV" begin
                N = 10_000
                hv1 = HV(N)
                hv2 = HV(N) 
                hv3 = HV(N) + hv1  # similar to 1 but not to 2
                normalize!(hv3)

                @test !(hv1 ≈ hv2)

                @test !(hv1 == hv2)
                @test (hv3 ≈ hv1)
                @test !(hv3 ≈ hv2)
            end
            
        end

    end

    #=
    @testset "offsetcombine" begin
        r = rand(10)
        x = rand(10)
        y = rand(10)

        @test offsetcombine!(r, +, x, y) ≈ x .+ y
        @test offsetcombine!(r, *, x, y) ≈ x .* y

        @test offsetcombine!(r, +, x, y, 2) ≈ x .+ circshift(y, 2)
        @test offsetcombine!(r, *, x, y, 2) ≈ x .* circshift(y, 2)

        @test offsetcombine(+, x, y) ≈ x .+ y
        @test offsetcombine(*, x, y) ≈ x .* y

        @test offsetcombine(+, x, y, 2) ≈ x .+ circshift(y, 2)
        @test offsetcombine(*, x, y, 2) ≈ x .* circshift(y, 2)
    end

    @testset "Bipolar" begin
        vectors = [[-1, 1, 1, -1],
                   [1, -1, -1, 1],
                   [-1, 1, 1, -1]]

        hdvs = BipolarHDV.(vectors)

        @test (hdvs[1] + hdvs[2] .== [0, 0, 0, 0]) |> all
        @test aggregate(hdvs) == last(hdvs)

        @test (hdvs[1] * hdvs[2] .== [-1, -1, -1, -1]) |> all
        @test bind(hdvs) == BipolarHDV([1, -1, -1, 1])

        hdv = first(hdvs)
        v = first(vectors) |> copy

        @test Π(hdv, 2) == circshift(v, 2)
        @test Π!(hdv, 2) == circshift(v, 2)
        @test resetoffset!(hdv) == v
        @test hdv.v == v 
    end

    @testset "Binary" begin
        vectors = [[true, false, false, true],
                   [true, false, false, true],
                   [false, true, true, false]]

        hdvs = BinaryHDV.(vectors)

        
        @test aggregate(hdvs) == BinaryHDV([true, false, false, true])

        @test (hdvs[1] * hdvs[2] .== [false, false, false, false]) |> all
        @test bind(hdvs[2:3]) == BinaryHDV([true, true, true, true])

        hdv = first(hdvs)
        v = first(vectors) |> copy

        @test Π(hdv, 2) == circshift(v, 2)
        @test Π!(hdv, 2) == circshift(v, 2)
        @test resetoffset!(hdv) == v
        @test hdv.v == v 
    end

    @testset "GradedBipolarHDV" begin
        vectors = [[0, 0, 0, 0.0],
                   [0.8, 0.1, -0.3, 0.2],
                   [-1.0, 1, 1, -1]]

        hdvs = GradedBipolarHDV.(vectors)

        @test hdvs[1] + hdvs[2] ≈ hdvs[2]
        @test aggregate(hdvs) ≈ last(hdvs)

        @test hdvs[1] * hdvs[2] ≈ hdvs[1]
        @test bind(hdvs) ≈ BipolarHDV([0.0, 0.0, 0.0, 0.0])


        hdv = first(hdvs)
        v = first(vectors) |> copy

        @test Π(hdv, 2) == circshift(v, 2)
        @test Π!(hdv, 2) == circshift(v, 2)
        @test resetoffset!(hdv) == v
        @test hdv.v == v 
    end

    @testset "GradedHDV" begin
        vectors = [[0.5, 0.5, 0.5, 0.5],
                   [0.8, 0.1, 0.3, 0.2],
                   [1.0, 0, 1, 0]]

        hdvs = GradedHDV.(vectors)

        @test hdvs[1] + hdvs[2] ≈ hdvs[2]
        @test aggregate(hdvs) ≈ last(hdvs)

        @test hdvs[1] * hdvs[2] ≈ hdvs[1]
        @test bind(hdvs) ≈ hdvs[1]

        hdv = first(hdvs)
        v = first(vectors) |> copy

        @test Π(hdv, 2) == circshift(v, 2)
        @test Π!(hdv, 2) == circshift(v, 2)
        @test resetoffset!(hdv) == v
        @test hdv.v == v 
    end

    @testset "RealHDV" begin
        vectors = [[0, 0, 0, 0.0],
                   [0.8, 0.1, -0.3, 0.2],
                   [-1.0, 1, 1, -1]]

        hdvs = RealHDV.(vectors)

        @test hdvs[1] + hdvs[2] ≈ hdvs[2] / sqrt(2)
        @test aggregate(hdvs) ≈ RealHDV(sum(vectors) / √(3))

        @test hdvs[1] * hdvs[2] ≈ hdvs[1]
        @test bind(hdvs) ≈ hdvs[1] .* hdvs[2] .* hdvs[3]


        hdv = first(hdvs)
        v = first(vectors) |> copy

        @test Π(hdv, 2) == circshift(v, 2)
        @test Π!(hdv, 2) == circshift(v, 2)
        @test resetoffset!(hdv) == v
        @test hdv.v == v 
    end
    =#
end