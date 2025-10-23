module HyperdimensionalComputing

using Distances, Random, Distributions, LinearAlgebra

include("types.jl")
export AbstractHV,
    BinaryHV,
    BipolarHV,
    GradedBipolarHV,
    RealHV,
    GradedHV,
    TernaryHV

include("operations.jl")
export bundle,
    bind,
    shift!,
    shift,
    ρ,
    ρ!,
    perturbate,
    perturbate!

include("encoding.jl")
export multiset,
    multibind,
    bundlesequence,
    bindsequence,
    hashtable,
    crossproduct,
    ngrams,
    graph,
    level,
    level_encoder,
    level_decoder,
    levels_encoder_decoder

include("inference.jl")
export similarity,
    nearest_neighbor


#include("learning.jl")

end
