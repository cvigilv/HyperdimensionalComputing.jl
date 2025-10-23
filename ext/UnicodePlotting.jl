module UnicodePlotting


#=
Representing the hypervectors using pretty printing
and a custom plotting recipe
=#

using StatsBase, UnicodePlots
using HyperdimensionalComputing

function unicodeheatmap(hv::AbstractHV)
    N = length(hv)
    nsq = floor(Int, sqrt(N))
    Np = nsq^2
    return heatmap(reshape(hv[1:Np], (nsq, nsq)))
end

function Base.show(io::IO, mime::MIME"text/plain", hv::AbstractHV)
    println(io, "$(length(hv))-element $(typeof(hv))")
    println(io, "mean ± std : $(round(mean(hv), digits = 3)) ± $(round(std(hv), digits = 3))")
    println(io, UnicodePlotting.histogram(hv.v))
    return println(io, unicodeheatmap(hv))
end

function Base.show(io::IO, mime::MIME"text/plain", hv::Union{BinaryHV,BipolarHV})
    counts = Dict(e => count(==(e), hv) for e in unique(hv))
    #n = hv isa BinaryHV ? 0 : -1  # negative element
    println(io, "$(length(hv))-element $(typeof(hv))")
    #println(io, "1 / $n : $(count(hv.v)) / $(length(hv) - count(hv.v))")
    println(io, barplot(counts))
    return println(io, unicodeheatmap(hv))
end

end
