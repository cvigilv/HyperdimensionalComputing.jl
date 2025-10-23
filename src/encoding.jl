"""
    multiset(vs::AbstractVector{<:T})::T where {T <: AbstractHV}

Multiset of input hypervectors, bundles all the input hypervectors together.

# Arguments
- `vs::AbstractVector{<:AbstractHV}`: Hypervectors

# Example
```
julia> vs = [BinaryHV(10) for _ in 1:10]
10-element Vector{BinaryHV}:
 [0, 1, 0, 0, 1, 1, 0, 1, 1, 1]
 [1, 0, 1, 0, 0, 0, 1, 1, 1, 0]
 [0, 1, 0, 1, 0, 0, 1, 0, 0, 0]
 [0, 1, 0, 1, 1, 0, 1, 0, 1, 0]
 [1, 1, 0, 0, 1, 0, 1, 1, 1, 0]
 [0, 0, 1, 1, 1, 1, 0, 0, 1, 0]
 [0, 0, 0, 0, 1, 1, 0, 1, 1, 0]
 [1, 1, 1, 0, 1, 1, 0, 0, 1, 1]
 [1, 1, 0, 1, 1, 0, 0, 0, 0, 0]
 [1, 1, 0, 0, 0, 1, 1, 0, 0, 0]

julia> multiset(vs)
10-element BinaryHV:
 0
 1
 0
 0
 1
 0
 0
 0
 1
 0
```

# Extended help

This encoding is based on the following mathematical notation:

```math
\\oplus_{i=1}^{m} V_i
```

where `V` is the hypervector collection, `m` is the size of the hypervector collection,
`i` is the position of the entry in the collection, and `\\oplus` is the bundling operation.

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.multiset.html)

# See also

- [`multibind`](@ref): Multibind encoding, binding-variant of this encoder
"""
function multiset(vs::AbstractVector{<:T})::T where {T <: AbstractHV}
    return bundle(vs)
end

"""
    multibind(vs::AbstractVector{<:AbstractHV})

Binding of multiple hypervectors, binds all the input hypervectors together.

# Arguments
- `vs::AbstractVector{<:AbstractHV}`: Hypervectors

# Examples
```
julia> vs = [BinaryHV(10) for _ in 1:10]
10-element Vector{BinaryHV}:
 [0, 1, 0, 0, 1, 1, 0, 1, 1, 1]
 [1, 0, 1, 0, 0, 0, 1, 1, 1, 0]
 [0, 1, 0, 1, 0, 0, 1, 0, 0, 0]
 [0, 1, 0, 1, 1, 0, 1, 0, 1, 0]
 [1, 1, 0, 0, 1, 0, 1, 1, 1, 0]
 [0, 0, 1, 1, 1, 1, 0, 0, 1, 0]
 [0, 0, 0, 0, 1, 1, 0, 1, 1, 0]
 [1, 1, 1, 0, 1, 1, 0, 0, 1, 1]
 [1, 1, 0, 1, 1, 0, 0, 0, 0, 0]
 [1, 1, 0, 0, 0, 1, 1, 0, 0, 0]

julia> multibind(vs)
10-element BinaryHV:
 1
 1
 1
 0
 1
 1
 1
 0
 1
 0
```

# Extended help

This encoding is based on the following mathematical notation:

```math
\\otimes_{i=1}^{m} V_i
```

where `V` is the hypervector collection, `m` is the size of the hypervector collection,
`i` is the position of the entry in the collection, and `\\otimes` is the binding operation.

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.multibind.html)

# See also

- [`multiset`](@ref): Multiset encoding, bundling-variant of this encoder
"""
function multibind(vs::AbstractVector{<:AbstractHV})
    return bind(vs)
end


"""
    bundlesequence(vs::AbstractVector{<:AbstractHV})

Bundling-based sequence. The first value is not permuted, the last value is permuted n-1 times.

# Arguments
- `vs::AbstractVector{<:AbstractHV}`: Hypervector sequence

# Examples
```
julia> vs = [BinaryHV(10) for _ in 1:10]
10-element Vector{BinaryHV}:
 [0, 1, 0, 0, 1, 1, 0, 1, 1, 1]
 [1, 0, 1, 0, 0, 0, 1, 1, 1, 0]
 [0, 1, 0, 1, 0, 0, 1, 0, 0, 0]
 [0, 1, 0, 1, 1, 0, 1, 0, 1, 0]
 [1, 1, 0, 0, 1, 0, 1, 1, 1, 0]
 [0, 0, 1, 1, 1, 1, 0, 0, 1, 0]
 [0, 0, 0, 0, 1, 1, 0, 1, 1, 0]
 [1, 1, 1, 0, 1, 1, 0, 0, 1, 1]
 [1, 1, 0, 1, 1, 0, 0, 0, 0, 0]
 [1, 1, 0, 0, 0, 1, 1, 0, 0, 0]

julia> bundlesequence(vs)
10-element BinaryHV:
 0
 1
 0
 0
 0
 0
 0
 0
 1
 1
```

# Extended help

This encoding is based on the following mathematical notation:

```math
\\oplus_{i=1}^{m} \\Pi(V_i, i-1)
```

where `V` is the hypervector collection, `m` is the size of the hypervector collection,
`i` is the position of the entry in the collection, and `\\oplus` and `\\Pi` are the
bundling and shift operations.

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.bundle_sequence.html)

# See also

- [`bindsequence`](@ref): Binding-sequence encoding, binding-variant of this encoder
"""
function bundlesequence(vs::AbstractVector{<:AbstractHV})
    @assert length(vs) > 1 "Can't bundle sequence of a single hypervector"
    return bundle([shift(hv, i - 1) for (i, hv) in enumerate(vs)])
end

"""
    bindsequence(vs::AbstractVector{<:AbstractHV})

Binding-based sequence. The first value is not permuted, the last value is permuted n-1 times.

# Arguments
- `vs::AbstractVector{<:AbstractHV}`: Hypervector sequence

# Examples
```
julia> vs = [BinaryHV(10) for _ in 1:10]
10-element Vector{BinaryHV}:
 [0, 1, 0, 0, 1, 1, 0, 1, 1, 1]
 [1, 0, 1, 0, 0, 0, 1, 1, 1, 0]
 [0, 1, 0, 1, 0, 0, 1, 0, 0, 0]
 [0, 1, 0, 1, 1, 0, 1, 0, 1, 0]
 [1, 1, 0, 0, 1, 0, 1, 1, 1, 0]
 [0, 0, 1, 1, 1, 1, 0, 0, 1, 0]
 [0, 0, 0, 0, 1, 1, 0, 1, 1, 0]
 [1, 1, 1, 0, 1, 1, 0, 0, 1, 1]
 [1, 1, 0, 1, 1, 0, 0, 0, 0, 0]
 [1, 1, 0, 0, 0, 1, 1, 0, 0, 0]

julia> bindsequence(vs)
10-element BinaryHV:
 0
 1
 1
 0
 1
 1
 0
 1
 1
 1
```

# Extended help

This encoding is based on the following mathematical notation:

```math
\\otimes_{i=1}^{m} \\Pi(V_i, i-1)
```

where `V` is the hypervector collection, `m` is the size of the hypervector collection,
`i` is the position of the entry in the collection, and `\\otimes` and `\\Pi` are the
binding and shift operations.

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.bind_sequence.html)

# See also

- [`bundlesequence`](@ref): Bundle-sequence encoding, bundling-variant of this encoder
"""
function bindsequence(vs::AbstractVector{<:AbstractHV})
    @assert length(vs) > 1 "Can't bind sequence of a single hypervector"
    return bind([shift(hv, i - 1) for (i, hv) in enumerate(vs)])
end

"""
    hashtable(keys::T, values::T) where {T <: AbstractVector{<:AbstractHV}}

Hash table from keys-values hypervector pairs. Keys and values must be the same length in order
to encode as hypervector.

# Arguments
- `keys::AbstractVector{<:AbstractHV}`: Keys hypervectors
- `values::AbstractVector{<:AbstractHV}`: Values hypervectors

# Example
```
julia> ks = [BinaryHV(10) for _ in 1:5]
5-element Vector{BinaryHV}:
 [0, 0, 0, 1, 0, 1, 1, 0, 0, 0]
 [1, 0, 1, 0, 1, 0, 1, 0, 1, 1]
 [0, 0, 0, 0, 1, 1, 1, 0, 1, 1]
 [1, 0, 0, 0, 0, 1, 1, 0, 1, 0]
 [0, 1, 1, 1, 1, 0, 0, 1, 1, 1]

julia> vs = [BinaryHV(10) for _ in 1:5]
5-element Vector{BinaryHV}:
 [0, 1, 0, 0, 1, 1, 0, 1, 0, 0]
 [1, 0, 1, 1, 1, 0, 1, 0, 0, 0]
 [0, 0, 0, 0, 0, 1, 1, 0, 1, 0]
 [0, 1, 1, 0, 0, 0, 0, 1, 0, 1]
 [0, 1, 1, 0, 0, 0, 1, 1, 0, 1]

julia> hashtable(ks, vs)
10-element BinaryHV:
 0
 0
 0
 1
 1
 0
 1
 0
 1
 1
```

# Extended help

This encoding is based on the following mathematical notation:

```math
\\oplus_{i=1}^{m} K_i \\otimes V_i
```

where `K` and `V` are the key and value hypervector collections, `m` is the size of the
hypervector collection, `i` is the position of the entry in the collection, and `\\otimes`
and `\\oplus` are the binding and bundling operations.

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.hash_table.html)
"""
function hashtable(keys::T, values::T) where {T <: AbstractVector{<:AbstractHV}}
    @assert length(keys) == length(values) "Number of keys and values aren't equal"
    return bundle(map(prod, zip(keys, values)))
end

"""
    crossproduct(U::T, V::T) where {T <: AbstractVector{<:AbstractHV}}

Cross product between two sets of hypervectors.


# Arguments
- `U::AbstractVector{<:AbstractHV}`: Hypervectors
- `V::AbstractVector{<:AbstractHV}`: Hypervectors

# Examples
```
julia> us = [BinaryHV(10) for _ in 1:5]
5-element Vector{BinaryHV}:
 [1, 1, 1, 1, 1, 0, 0, 1, 0, 0]
 [0, 1, 0, 0, 1, 1, 1, 0, 1, 0]
 [0, 1, 1, 1, 1, 0, 0, 1, 1, 1]
 [0, 1, 1, 0, 1, 0, 1, 1, 1, 0]
 [1, 0, 0, 1, 0, 0, 1, 1, 1, 1]

julia> vs = [BinaryHV(10) for _ in 1:5]
5-element Vector{BinaryHV}:
 [0, 1, 1, 1, 1, 1, 0, 1, 0, 0]
 [0, 0, 1, 0, 0, 1, 1, 0, 0, 1]
 [0, 0, 0, 0, 1, 0, 0, 1, 0, 1]
 [1, 0, 1, 1, 0, 1, 1, 1, 1, 1]
 [1, 0, 1, 0, 0, 1, 0, 1, 0, 1]

julia> crossproduct(us, vs)
10-element BinaryHV:
 0
 0
 1
 0
 1
 0
 0
 1
 0
 1
```

# Extended help

This encoding strategy first creates a multiset from both input hypervector sets,
which are then bound together to generate all cross products, i.e.

U₁ × V₁ + U₁ × V₂ + ... + U₁ × Vₘ + ... + Uₙ × Vₘ

This encoding is based on the following formula:

```math
(\\oplus_{i=1}^{m} U_i) \\otimes (\\oplus_{i=1}^{n} V_i)
```

where U and V are collections of hypervectors, `m` and `n` are the sizes of the U and V collections,
`ì` is the position in the hypervector collection, and `\\oplus` and `\\otimes` are the bundling
and binding operations.

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.cross_product.html)
"""
function crossproduct(U::T, V::T) where {T <: AbstractVector{<:AbstractHV}}
    # TODO: This should be bundled without normalizing
    return bind(multiset(U), multiset(V))
end

"""
    ngrams(vs::AbstractVector{<:AbstractHV}, n::Int = 3)

Creates a hypervector with the _n_-gram statistics of the input.

# Arguments
- `vs::AbstractVector{<:AbstractHV}`: Hypervector collection
- `n::Int = 3`: _n_-gram size

# Examples
```
julia> vs = [BinaryHV(10) for _ in 1:10]
10-element Vector{BinaryHV}:
 [0, 1, 0, 0, 1, 0, 1, 0, 0, 1]
 [0, 0, 1, 1, 1, 0, 0, 1, 1, 1]
 [0, 0, 1, 0, 0, 1, 1, 1, 0, 0]
 [1, 0, 0, 0, 1, 0, 0, 1, 1, 1]
 [0, 1, 0, 0, 1, 0, 1, 1, 0, 0]
 [1, 1, 1, 0, 1, 0, 0, 1, 0, 1]
 [1, 0, 0, 0, 1, 0, 0, 1, 1, 0]
 [0, 1, 0, 1, 0, 0, 0, 1, 1, 0]
 [0, 0, 0, 1, 1, 1, 1, 0, 0, 1]
 [1, 1, 0, 0, 0, 1, 1, 1, 0, 1]

julia> ngrams(vs)
10-element BinaryHV:
 1
 1
 1
 1
 1
 1
 0
 1
 0
 1
```

# Extended help

This encoding is defined by the following mathematical notation:

```math
\\oplus_{i=1}^{m-n}\\otimes_{j=1}^{n-1}\\Pi^{n-j-1}(V_{i+j})
```

where `V` is the collection of hypervectors, `m` is the number of hypervectors in the
collection `V`, `n` is the window size, `i` is the position in the sequence, `j` is the
position in the _n_-gram, and `\\oplus`, `\\otimes` and `\\Pi` are the bundling, binding
and shift operations.

!!! note
    - For `n = 1` use `multiset()` instead
    - For `n = m` use `bindsequence()` instead

# See also

- [`multiset`](@ref): Multiset encoding, equivalent to `ngram(vs, 1)`
- [`bindsequence`](@ref): Bind-sequence encoding, equivalent to `ngram(vs, length(vs))`

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.ngrams.html)

"""
function ngrams(vs::AbstractVector{<:AbstractHV}, n::Int = 3)
    l = length(vs)
    p = l - n + 1
    @assert 1 <= n <= length(vs) "`n` must be 1 ≤ n ≤ $l"
    return bundle([bind([shift(vs[i + j], j) for j in 0:(n - 1)]) for i in 1:p])
end

"""
    graph(source::T, target::T, directed::Bool = false)

Graph for `source`-`target` pairs. Can be directed or undirected.

# Arguments
- `source::T`: Source node hypervectors
- `target::T`: Target node hypervectors
- `directed::Bool = false`: Whether the graph is directed or not

# Example

# Extended help

This encoding is based on the following mathematical notation:

*Undirected graphs*
```math
\\otimes_{i=1}^{m} S_i \\otimes T_i
```

*Directed graphs*
```math
\\otimes_{i=1}^{m} S_i \\otimes \\Pi(T_i)
```

where `K` and `V` are the key and value hypervector collections, `m` is the size of the
hypervector collection, `i` is the position of the entry in the collection, and `\\otimes`,
`\\oplus` and `\\Pi` are the binding, bundling and shift operations.

# See also

- [`hashtable`](@ref): Hash table encoding, underlying encoding strategy of this encoder.

# References

- [Torchhd documentation](https://torchhd.readthedocs.io/en/stable/generated/torchhd.graph.html)

"""
function graph(source::T, target::T; directed::Bool = false) where {T <: AbstractVector{<:AbstractHV}}
    @assert length(source) == length(target) "`source` and `target` must be the same length"
    return hashtable(source, shift.(target, convert(Int, directed)))
end


"""
	level(v::HV, n::Int) where {HV <: AbstractHV}
	level(HV::Type{<:AbstractHV}, n::Int; dims::Int = 10_000)

Creates a set of level correlated hypervectors, where the first and last hypervectors are quasi-orthogonal.

# Arguments
- `v::HV`: Base hypervector
- `n::Int`: Number of levels (alternatively, provide a vector to be encoded)
"""
function level(v::HV, n::Int) where {HV <: AbstractHV}
    hvs = [v]
    p = 2 / n
    while length(hvs) < n
        u = last(hvs)
        push!(hvs, perturbate(u, p))
    end
    return hvs
end

level(HV::Type{<:AbstractHV}, n::Int; dims::Int = 10_000) = level(HV(dims), n)

level(HVv, vals::AbstractVector) = level(HVv, length(vals))
level(HVv, vals::UnitRange) = level(HVv, length(vals))


"""
    level_encoder(hvlevels::AbstractVector{<:AbstractHV}, numvalues; testbound=false)

Generate an encoding function based on `level`, for encoding numerical values. It returns a function
that gives the corresponding hypervector for a given numerical input.

# Arguments
- hvlevels::AbstractVector{<:AbstractHV}: vector of hypervectors representing the level encoding
- numvalues: the range or vector with the corresponding numerical values
- [testbound=false]: optional keyword argument to check whether the provided value is in bounds

# Example
```julia
numvalues = range(0, 2pi, 100)
hvlevels = level(BipolarHV(), 100)

encoder = level_encoder(hvlevels, numvalues)

encoder(pi/3)  # hypervector that best represents this numerical value
```
"""
function level_encoder(hvlevels::AbstractVector{<:AbstractHV}, numvalues; testbound = false)
    @assert length(hvlevels) == length(numvalues) "HV levels do not match numerical values"
    # construct the encoder
    function encoder(x::Number)
        @assert !testbound || minimum(numvalues) ≤ x ≤ maximum(numvalues) "x not in numerical range"
        (_, ind) = findmin(v -> abs(x - v), numvalues)
        return hvlevels[ind]
    end
    return encoder
end

"""
    level_encoder(hvlevels::AbstractVector{<:AbstractHV}, a::Number, b::Number; testbound=false)

See `level_encoder`, same but provide lower (`a`) and upper (`b`) limit of the interval to be encoded.
"""
level_encoder(hvlevels::AbstractVector{<:AbstractHV}, a::Number, b::Number; testbound = false) = level_encoder(hvlevels, range(a, b, length(hvlevels)); testbound)

level_encoder(HV, numvalues; testbound = false) = level_encoder(level(HV, length(numvalues)), numvalues; testbound)


"""
    level_decoder(hvlevels::AbstractVector{<:AbstractHV}, numvalues)

Generate a decoding function based on `level`, for decoding numerical values. It returns a function
that gives the numerical value for a given hypervector, based on similarity matching.

# Arguments
- hvlevels::AbstractVector{<:AbstractHV}: vector of hypervectors representing the level encoding
- numvalues: the range or vector with the corresponding numerical values

# Example
```julia
numvalues = range(0, 2pi, 100)
hvlevels = level(BipolarHV(), 100)

decoder = level_decoder(hvlevels, numvalues)

decoder(hvlevels[17])  # value that closely matches the corresponding HV
```
"""
function level_decoder(hvlevels::AbstractVector{<:AbstractHV}, numvalues)
    @assert length(hvlevels) == length(numvalues) "HV levels do not match numerical values"
    # construct the decoder
    function decoder(hv::AbstractHV)
        (_, ind) = findmax(v -> similarity(v, hv), hvlevels)
        return numvalues[ind]
    end
    return decoder
end

level_decoder(hvlevels::AbstractVector{<:AbstractHV}, a::Number, b::Number) = level_decoder(hvlevels, range(a, b, length(hvlevels)))

level_decoder(HV, numvalues; testbound = false) = level_decoder(level(HV, length(numvalues)), numvalues)

"""
    levels_encoder_decoder(hvlevels, numvals..., kwargs...)

Creates the `encoder` and `decoder` for a level incoding in one step. See `level_encoder`
and `level_decoder` for their respective documentations.
"""
levels_encoder_decoder(hvlevels, numvals...; kwargs...) = level_encoder(hvlevels, numvals...; kwargs...), level_decoder(hvlevels, numvals..., kwargs...)
