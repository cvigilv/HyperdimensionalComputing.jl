#=
This file implements all similarity metrics + modules for finding the closest match.
=#

using LinearAlgebra

LinearAlgebra.dot(u::AbstractHV, v::AbstractHV) = dot(u.v, v.v)

LinearAlgebra.dot(u::BipolarHV, v::BipolarHV) = 4dot(u.v, v.v) - 2sum(u.v) - 2sum(v.v) + length(u)

sim_cos(u::AbstractVector, v::AbstractVector) = dot(u, v) / (norm(u) * norm(v))

sim_jacc(u::AbstractVector, v::AbstractVector) = dot(u, v) / sum(ui + vi - ui * vi for (ui, vi) in zip(u, v))

dist_hamming(u::AbstractVector, v::AbstractVector) = sum(abs(ui - vi) for (ui, vi) in zip(u, v))

similarity(x::BipolarHV, y::BipolarHV) = sim_cos(x, y)
similarity(x::TernaryHV, y::TernaryHV) = sim_cos(x, y)
similarity(x::GradedBipolarHV, y::GradedBipolarHV) = sim_cos(x, y)
similarity(x::RealHV, y::RealHV) = sim_cos(x, y)
similarity(x::BinaryHV, y::BinaryHV) = sim_jacc(x, y)
similarity(x::GradedHV, y::GradedHV) = sim_jacc(x, y)

"""
    similarity(x::AbstractVector, y::AbstractVector; method::Symbol)

Computes similarity between two (hyper)vectors using a `method` ∈
`[:cosine, :jaccard, :hamming]`. When no method is given, a default is used
(cosine for vectors that can have negative elements and Jaccard for those that
only have positive elements).
"""
function similarity(x::AbstractVector, y::AbstractVector; method::Symbol)
    @assert length(x) == length(y) "Vectors have to be of the same length"
    methods = [:cosine, :jaccard, :hamming]
    @assert method ∈ methods "`method` has to be one of $methods"
    if method == :cosine
        return sim_cos(x, y)
    elseif method == :jaccard
        return sim_jacc(x, y)
    elseif method == :hamming
        return length(x) - dist_hamming(x, y)
    end
end

nearest_neighbor(x, collection; kwargs...) =
    maximum(
    (similarity(x, xi; kwargs...), i, xi)
        for (i, xi) in enumerate(collection)
)

nearest_neighbor(x, collection::Dict; kwargs...) =
    maximum((similarity(x, xi; kwargs...), k, xi) for (k, xi) in collection)

"""
    nearest_neighbor(x, collection[, k::Int]; kwargs...)

Returns the element of `collection` that is most similar to `x`. 

Function outputs `(τ, i, xi)` with `τ` the highest similarity value,
`i` the index (or key if `collection` is a dictionary) of the closest 
neighbor and `xi` the closest vector. `kwargs` is an optional argument
for the similarity search.

If a number `k` is given, the `k` closest neighbor are returned, as a sorted
list of `(τ, i)`.
"""
function nearest_neighbor(x, collection, k::Int; kwargs...)
    sims = [
        (similarity(x, xi; kwargs...), i)
            for (i, xi) in enumerate(collection)
    ]
    return partialsort!(sims, 1:k, rev = true)
end

function nearest_neighbor(x, collection::Dict, k::Int; kwargs...)
    sims = [
        (similarity(x, xi; kwargs...), i)
            for (i, xi) in collection
    ]
    return partialsort!(sims, 1:k, rev = true)
end
