#=
types.jl

Implements the basic types for the different hypervectors (wrappers for ordinary vectors)

Contains:
- BinaryHV
- BipolarHV
- TernaryHV
- RealHV
- GradedHV
- GradedBipolarHV

Every hypervector HV has the following basic functionality
- random generation using the Constructor ()
- norm/sum/normalize...

TODO:
- [ ] SparseHV
- [ ] support for different types
- [ ] complex HDC
=#

# ----------------------------------------------------------------------------------- AbstractHV
abstract type AbstractHV{T} <: AbstractVector{T} end

Base.copy(hv::HV) where {HV <: AbstractHV} = HV(copy(hv.v))
Base.getindex(hv::AbstractHV, i) = hv.v[i]
Base.hash(hv::AbstractHV) = hash(hv.v)
Base.similar(hv::T) where {T <: AbstractHV} = T(; dims = length(hv))
Base.size(hv::AbstractHV) = size(hv.v)
Base.sum(hv::AbstractHV) = sum(hv.v)

LinearAlgebra.norm(hv::AbstractHV) = norm(hv.v)
LinearAlgebra.normalize!(hv::AbstractHV) = hv

eldist(hv::AbstractHV) = eldist(typeof(hv))
empty_vector(hv::AbstractHV) = zero(hv.v)


# ------------------------------------------------------------------------------------ BipolarHV
struct BipolarHV <: AbstractHV{Int}
    v::BitVector

    BipolarHV(v::AbstractVector{Bool}) = new(v)
end

function BipolarHV(;
        dims::Integer = 10_000,
        seed::Union{Number, Nothing} = nothing,
        rng = MersenneTwister
    )
    rng_instance = isnothing(seed) ? rng() : rng(seed)
    return BipolarHV(bitrand(rng_instance, dims))
end

function BipolarHV(
        s::Any;
        dims::Integer = 10_000,
        rng = MersenneTwister
    )
    rng_instance = rng(hash(s))
    return BipolarHV(bitrand(rng_instance, dims))
end

# Helpers
Base.getindex(hv::BipolarHV, i) = hv.v[i] ? 1 : -1
Base.sum(hv::BipolarHV) = 2sum(hv.v) - length(hv.v)
LinearAlgebra.norm(hv::BipolarHV) = sqrt(length(hv))
empty_vector(hv::BipolarHV) = zeros(Int, length(hv))
eldist(::Type{BipolarHV}) = 2Bernoulli(0.5) - 1


# ------------------------------------------------------------------------------------ TernaryHV
"""
    TernaryHV

A ternary hypervector type based on the Multiply-Add-Permute (MAP) vector symbolic architecture
(Gayler, 1998).

Represents a hypervector with elements in `(-1, 1)`.

# Extended help

## References

- Gayler, R. W. (1998). Multiplicative Binding, Representation Operators & Analogy. In Advances in Analogy Research: Integration of Theory and Data from the Cognitive, Computational, and Neural Sciences, pages 1–4.
"""
struct TernaryHV <: AbstractHV{Int}
    v::Vector{Int}

    TernaryHV(v::AbstractVector{<:Integer}) = new(v)
end

function TernaryHV(;
        dims::Integer = 10_000,
        seed::Union{Integer, Nothing} = nothing,
        rng = Random.MersenneTwister
    )
    rng_instance = isnothing(seed) ? rng() : rng(seed)
    return TernaryHV(rand(rng_instance, (-1, 1), dims))
end

function TernaryHV(
        s::Any;
        dims::Integer = 10_000,
        rng = Random.MersenneTwister
    )
    rng_instance = rng(hash(s))
    return TernaryHV(rand(rng_instance, (-1, 1), dims))
end

# Helpers
LinearAlgebra.normalize!(hv::TernaryHV) = clamp!(hv.v, -1, 1)
LinearAlgebra.normalize(hv::TernaryHV) = TernaryHV(clamp.(hv, -1, 1))
eldist(::Type{TernaryHV}) = 2Bernoulli(0.5) - 1
# ------------------------------------------------------------------------------------ BinaryHV
"""
    BinaryHV

A ternary hypervector type based on the Binary Splatter Code (BSC) vector symbolic architecture
(Kanerva, 1994; Kanerva, 1995; Kanerva, 1996; Kanerva, 1997).

Represents a hypervector boolean elements, i.e. `(false, true)`.

# Extended help

## References

- Kanerva, P. (1994). The Spatter Code for Encoding Concepts at Many Levels. In International Conference on Artificial Neural Networks (ICANN), pages 226–229.
- Kanerva, P. (1995). A Family of Binary Spatter Codes. In International Conference on Artificial Neural Networks (ICANN), pages 517–522.
- Kanerva, P. (1996). Binary Spatter-Coding of Ordered K-tuples. In International Conference on Artificial Neural Networks (ICANN), volume 1112 of Lecture Notes in Computer Science, pages 869–873.
- Kanerva, P. (1997). Fully Distributed Representation. In Real World Computing Symposium (RWC), pages 358–365.
"""
struct BinaryHV <: AbstractHV{Bool}
    v::BitVector

    BinaryHV(v::AbstractVector{Bool}) = new(v)
end

function BinaryHV(;
        dims::Integer = 10_000,
        seed::Union{Integer, Nothing} = nothing,
        rng = Random.MersenneTwister
    )
    rng_instance = isnothing(seed) ? rng() : rng(seed)
    return BinaryHV(bitrand(rng_instance, dims))
end

function BinaryHV(
        s::Any;
        dims::Integer = 10_000,
        rng = Random.MersenneTwister
    )
    rng_instance = rng(hash(s))
    return BinaryHV(bitrand(rng_instance, dims))
end

# Helpers
empty_vector(hv::BinaryHV) = zeros(Int, length(hv))
eldist(::Type{BinaryHV}) = Bernoulli(0.5)


# --------------------------------------------------------------------------------------- RealHV
struct RealHV{T <: Real} <: AbstractHV{T}
    v::Vector{T}
    distr::Distribution

    RealHV(
        v::AbstractVector{T},
        distr::Distribution = eldist(RealHV)
    ) where {T <: Real} = new{T}(v, distr)
end

function RealHV(;
        distr::Distribution = eldist(RealHV),
        dims::Integer = 10_000,
        seed::Union{Integer, Nothing} = nothing,
        rng = Random.MersenneTwister
    )
    rng_instance = isnothing(seed) ? rng() : rng(seed)
    return RealHV(rand(rng_instance, distr, dims), distr)
end

function RealHV(
        s::Any;
        dims::Integer = 10_000,
        distr::Distribution = eldist(RealHV),
        rng = Random.MersenneTwister
    )
    rng_instance = rng(hash(s))
    return RealHV(rand(rng_instance, distr, dims), distr)
end

# Helpers
Base.copy(hv::RealHV) = RealHV(copy(hv.v), hv.distr)
Base.similar(hv::RealHV) = RealHV(; dims = length(hv), distr = hv.distr)
function normalize!(hv::RealHV)
    hv.v .*= std(hv.distr) / std(hv.v)
    return hv
end
eldist(::Type{<:RealHV}) = Normal()


# -------------------------------------------------------------------------------------- GradedHV
struct GradedHV{T <: Real} <: AbstractHV{T}
    v::Vector{T}
    distr::Distribution

    GradedHV(
        v::AbstractVector{T},
        distr::Distribution = eldist(GradedHV)
    ) where {T <: Real} = new{T}(clamp.(v, 0, 1), distr)
end

function GradedHV(;
        dims::Integer = 10_000,
        distr::Distribution = eldist(GradedHV),
        seed::Union{Integer, Nothing} = nothing,
        rng = Random.MersenneTwister
    )
    @assert 0 ≤ minimum(distr) < maximum(distr) ≤ 1 "Provide `distr` with support in [0,1]"
    rng_instance = isnothing(seed) ? rng() : rng(seed)
    return GradedHV(rand(rng_instance, distr, dims), distr)
end

function GradedHV(
        s::Any;
        dims::Integer = 10_000,
        distr::Distribution = eldist(GradedHV),
        rng = Random.MersenneTwister
    )
    @assert 0 ≤ minimum(distr) < maximum(distr) ≤ 1 "Provide `distr` with support in [0,1]"
    rng_instance = rng(hash(s))
    return GradedHV(rand(rng_instance, distr, dims), distr)
end

# Helpers
Base.copy(hv::GradedHV) = GradedHV(copy(hv.v), hv.distr)
Base.similar(hv::GradedHV) = GradedHV(; dims = length(hv), distr = eldist(GradedHV))
Base.zeros(hv::GradedHV) = fill!(similar(hv.v), one(eltype(hv.v)) / 2)
LinearAlgebra.normalize!(hv::GradedHV) = clamp!(hv.v, 0, 1)
eldist(::Type{<:GradedHV}) = Beta(1, 1)
empty_vector(hv::GradedHV) = fill!(zero(hv.v), 0.5)


# -------------------------------------------------------------------------------- GradedBipolarHV
struct GradedBipolarHV{T <: Real} <: AbstractHV{T}
    v::Vector{T}
    distr::Distribution

    GradedBipolarHV(
        v::AbstractVector{T},
        distr::Distribution = eldist(GradedBipolarHV)
    ) where {T <: Real} = new{T}(clamp.(v, -1, 1), distr)
end

function GradedBipolarHV(;
        dims::Integer = 10_000,
        distr::Distribution = eldist(GradedBipolarHV),
        seed::Union{Integer, Nothing} = nothing,
        rng = Random.MersenneTwister
    )
    @assert -1 ≤ minimum(distr) < maximum(distr) ≤ 1 "Provide `distr` with support in [-1,1]"
    rng_instance = isnothing(seed) ? rng() : rng(seed)
    return GradedBipolarHV(rand(rng_instance, distr, dims), distr)
end

function GradedBipolarHV(
        s::Any;
        dims::Integer = 10_000,
        distr::Distribution = eldist(GradedBipolarHV),
        rng = Random.MersenneTwister
    )
    @assert -1 ≤ minimum(distr) < maximum(distr) ≤ 1 "Provide `distr` with support in [-1,1]"
    rng_instance = rng(hash(s))
    return GradedBipolarHV(rand(rng_instance, distr, dims), distr)
end

# Helpers
Base.copy(hv::GradedBipolarHV) = GradedBipolarHV(copy(hv.v), hv.distr)
Base.similar(hv::GradedBipolarHV) = GradedBipolarHV(; dims = length(hv), distr = hv.distr)
LinearAlgebra.normalize!(hv::GradedBipolarHV) = clamp!(hv.v, -1, 1)
eldist(::Type{<:GradedBipolarHV}) = 2Beta(1, 1) - 1


# ---------------------------------------------------------------------------------------  Traits
abstract type HVTraits end

struct HVByteVec <: HVTraits end
struct HVBitVec <: HVTraits end

vectype(::AbstractHV) = HVByteVec
vectype(::BinaryHV) = HVBitVec
vectype(::BipolarHV) = HVBitVec
