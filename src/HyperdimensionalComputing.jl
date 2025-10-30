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
    encodelevel,
    decodelevel,
    convertlevel

include("inference.jl")
export similarity,
    δ,
    nearest_neighbor


#include("learning.jl")

end
