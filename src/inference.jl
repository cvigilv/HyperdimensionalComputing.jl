#=
inference.jl; This file implements functions to compare two hyperdimensional vectors.
=#

using LinearAlgebra

LinearAlgebra.dot(u::AbstractHV, v::AbstractHV) = dot(u.v, v.v)

LinearAlgebra.dot(u::BipolarHV, v::BipolarHV) = 4dot(u.v, v.v) - 2sum(u.v) - 2sum(v.v) + length(u)

sim_cos(u::AbstractVector, v::AbstractVector) = dot(u, v) / (norm(u) * norm(v))

sim_jacc(u::AbstractVector, v::AbstractVector) = dot(u, v) / sum(ui+vi-ui*vi for (ui, vi) in zip(u, v))

dist_hamming(u::AbstractVector, v::AbstractVector) = sum(abs(ui-vi) for (ui, vi) in zip(u, v))

similarity(x::BipolarHV, y::BipolarHV) = sim_cos(x, y)
similarity(x::TernaryHV, y::TernaryHV) = sim_cos(x, y)
similarity(x::GradedBipolarHV, y::GradedBipolarHV) = sim_cos(x, y)
similarity(x::RealHV, y::RealHV) = sim_cos(x, y)

similarity(x::BinaryHV, y::BinaryHV) = sim_jacc(x, y)
similarity(x::GradedHV, y::GradedHV) = sim_jacc(x, y)


#=
function LinearAlgebra.dot(x::AbstractHDV, y::AbstractHDV)
    nx = normalizer(x)
    ny = normalizer(y)
    if x.offset == y.offset  
        return sum(((vx,vy),)->dot(nx(vx),ny(vy)), zip(x.v, y.v))
    else
        return sum(((vx,vy),)->dot(nx(vx),ny(vy)), zip(x, y))
    end
end

cos_sim(x::AbstractVector, y::AbstractVector) = dot(x, y) / (norm(x) * norm(y))

jacc_sim(x::AbstractVector, y::AbstractVector) = dot(x, y) / sum(t->t[1]+t[2]-t[1]*t[2], zip(x,y))

# specific similarities
# for HDVs that can both be pos and neg,
# we use cosine similarity



#strange_fun(x, y) = sum((a, b)->max(a*b-sqrt(1-a^2)*sqrt(1-b^2),0.0), zip(x, y))
=#