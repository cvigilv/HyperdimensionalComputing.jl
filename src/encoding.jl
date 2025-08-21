function multiset(vs::AbstractVector{AbstractHDV})
    return aggregate(vs...; norm = false)

end

function multibind(vs::AbstractVector{AbstractHDV})
    return bind(vs...)
end

function bundlesequence(vs::Vector{AbstractHDV})
    return length(vs) == 1 ? [vs] : aggregate([Π(hv, i) for (i, hv) in enumerate(vs)]...)
end

function bindsequence(vs::Vector{AbstractHDV})
    @assert length(vs) > 1 "Can't bind sequence of a single hypervector"
    return bind([Π(hv, i) for (i, hv) in enumerate(vs)]...)
end

function hashtable(keys::T, values::T) where {T <: AbstractVector{AbstractHDV}}
    @assert length(keys) == length(values) "Number of keys and values aren't equal"
    return aggregate(map(bind, zip(keys, values)...))
end

function crossproduct(U::T, V::T) where {T <: AbstractVector{AbstractHDV}}
    return aggregate(multiset(U), multiset(V))
end

function ngrams(vs::AbstractVector{AbstractHDV}, n::Int = 3)
    m = length(vs)
    @assert 1 <= n <= length(vs) "`n` must be 1 ≤ n ≤ $m"
    return aggregate([bind([Π(vs[i + j], j - 1) for j in 1:n]...) for i in 1:(m - n)]...)
end
