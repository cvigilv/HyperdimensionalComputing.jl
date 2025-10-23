#=
Representing the hypervectors using pretty printing
and a custom plotting recipe

See ext/UnicodePlotting.jl for extensions based on UnicodePlotting
=#

function Base.show(io::IO, mime::MIME"text/plain", hv::AbstractHV)
    println(io, "$(length(hv))-element $(typeof(hv))")
    return println(io, "mean ± std : $(round(mean(hv), digits = 3)) ± $(round(std(hv), digits = 3))")
end

function Base.show(io::IO, mime::MIME"text/plain", hv::Union{BinaryHV,BipolarHV})
    counts = Dict(e => count(==(e), hv) for e in unique(hv))
    n = hv isa BinaryHV ? 0 : -1  # negative element
    println(io, "$(length(hv))-element $(typeof(hv))")
    return println(io, "1 / $n : $(count(hv.v)) / $(length(hv) - count(hv.v))")

end

function Base.show(io::IO, hv::AbstractHV)
    return print(io, "$(length(hv))-element $(typeof(hv)) - m ± sd: $(round(mean(hv))) ± $(round(std(hv)))")
end

function Base.show(io::IO, hv::Union{BinaryHV,BipolarHV})
    n = hv isa BinaryHV ? 0 : -1  # negative element
    return print(io, "1 / $n : $(count(hv.v)) / $(length(hv) - count(hv.v))")
end
