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

TODO: 
- [ ] SparseHV
- [ ] support for different types
=#


abstract type AbstractHV{T} <: AbstractVector{T} end

Base.collect(hv::AbstractHV) = hv.v
Base.sum(hv::AbstractHV) = sum(hv.v)
Base.size(hv::AbstractHV) = size(hv.v)
Base.getindex(hv::AbstractHV, i) = hv.v[i]
Base.similar(hv::T) where {T<: AbstractHV} = T(length(hv)) 
LinearAlgebra.norm(hv::AbstractHV) = norm(hv.v)
LinearAlgebra.normalize!(hv::AbstractHV) = hv

get_vector(v::AbstractVector) = v
get_vector(hv::AbstractHV) = hv.v

# We always provide a constructor with optinal dimensionality (n=10,000 by default) and
# a method `similar`.

# BipolarHV

struct BipolarHV <: AbstractHV{Int}
    v::BitVector
    BipolarHV(v::BitVector) = new(v)
end

BipolarHV(n::Integer=10_000) = BipolarHV(bitrand(n))
BipolarHV(v::AbstractVector) = BipolarHV(v.>0)

Base.getindex(hv::BipolarHV, i) = hv.v[i] ? 1 : -1
Base.sum(hv::BipolarHV) = 2sum(hv.v) - length(hv.v)

# TernaryHV

struct TernaryHV <: AbstractHV{Int}
    v::Vector{Int}
end

TernaryHV(n::Int=10_000) = TernaryHV(rand((-1, 1), n))

function LinearAlgebra.normalize!(hv::TernaryHV)
    clamp!(hv.v, -1, 1)
    return hv
end

LinearAlgebra.normalize(hv::TernaryHV) = TernaryHV(clamp.(hv, -1, 1))


# `BinaryHV` contain binary vectors.

struct BinaryHV <: AbstractHV{Bool}
    v::BitVector
end

BinaryHV(n::Integer=10_000) = BinaryHV(bitrand(n))
BinaryHV(v::AbstractVector{Bool}) = BinaryHV(BitVector(v))

# `RealHV` contain real numbers, drawn from a distribution
struct RealHV{T<:Real,D<:Distribution} <: AbstractHV{T}
    v::Vector{T}
    distr::D
end

RealHV(distr::Distribution, n::Integer=10_000) = RealHV(rand(distr,n), distr)
RealHV(n::Integer=10_000) = RealHV(Normal(0,1), n)
RealHV(v::AbstractVector, dist=Normal(mean(v),std(v))) = RealHV(v, distr)

Base.similar(hv::RealHV) = RealHV(Normal(0,1), length(hv)) 

function normalize!(hv::RealHV)
    hv.v .*= std(hv.distr) / std(hv.v)
    return hv
end


# GradedHV are vectors in $[0, 1]^n$, allowing for graded relations.

# distribution used for sampling graded HVs
graded_distr = Beta(1,1)

struct GradedHV{T<:Real,D<:Distribution} <: AbstractHV{T}
    v::Vector{T}
end

function GradedHV(distr::Distribution=graded_distr, n::Int=10_000)
    @assert 0 ≤ minimum(distr) < maximum(distr) ≤ 1 "Provide `distr` with support in [0,1]"
    GradedHV(rand(distr, n))
end

GradedHV(n::Int=10_000) = GradedHV(graded_distr, n)
GradedHV(v::AbstractVector) = GradedHV(v)

Base.similar(hv::GradedHV) = GradedHV(graded_distr, length(hv))
LinearAlgebra.normalize!(hv::GradedHV) = clamp!(hv.v, 0, 1)


# GradedBipolarHV are vectors in $[-1, 1]^n$, allowing for graded relations.

# distribution used for sampling graded bipolar HVs
graded_bipol_distr = 2graded_distr - 1

struct GradedBipolarHV{T<:Real,D<:Distribution} <: AbstractHV{T}
    v::Vector{T}
end

function GradedBipolarHV(distr::Distribution=graded_bipol_distr, n::Int=10_000)
    @assert -1 ≤ minimum(distr) < maximum(distr) ≤ 1 "Provide `distr` with support in [-1,1]"
    GradedBipolarHV(rand(distr, n))
end

GradedBipolarHV(n::Int=10_000) = GradedBipolarHV(graded_bipol_distr, n)
GradedBipolarHV(v::AbstractVector) = GradedBipolarHV(v)


Base.similar(hv::GradedBipolarHV) = GradedBipolarHV(hv.distr, length(hv))
LinearAlgebra.normalize!(hv::GradedBipolarHV) = clamp!(hv.v, -1, 1)
