using HyperdimensionalComputing
using MLDatasets, DataFrames

# Load Iris dataset
X, y = Iris(as_df = false)[:]

# # Encoding
#
# The first thing we need to do in order to work with HDC is to encode our problem into
# hyperdimensional space. For that, we need to propose an encoder that converts our objects in
# real space (denoted as R) into hypervectors representing the hyperdimensional space (denoted
# as H).
#
# In this simple, classical example, we will employ the key-value encoder, which
# Encode feature names as hypervectors
SEPALLENGTH = BinaryHV()
SEPALWIDTH = BinaryHV()
PETALLENGTH = BinaryHV()
PETALWIDTH = BinaryHV()

# Encode values names as level hypervectors
centimeters = range(extrema(X)...; step = 0.1)
centimeters_hvs = level(BinaryHV, length(centimeters))

# Encode entries as hypervectors
function encode(features::AbstractVector{Float64})
    sl, sw, pl, pw = features
    return SEPALLENGTH * centimeters_hvs[findfirst(==(sl), centimeters)] +
        SEPALWIDTH * centimeters_hvs[findfirst(==(sw), centimeters)] +
        PETALLENGTH * centimeters_hvs[findfirst(==(pl), centimeters)] +
        PETALWIDTH * centimeters_hvs[findfirst(==(pw), centimeters)]
end

flower_hvs = map(encode, eachcol(X))

# # Decoding
#
# Once we have our hypervectors, we can use the same operations to decode this back into the
# original space. For this, we exploit the properties of HDC and make use of approximatations to
# obtain the original elements.
#
# Let's start selecting a random entry from the dataset

entry_hv = flower_hvs[rand(1:size(X, 2))]

# From here, we can obtain the approximate hypervectors for the features that constitute it
# via unbinding:

entry_hv * SEPALWIDTH
entry_hv * SEPALLENGTH
entry_hv * PETALWIDTH
entry_hv * PETALLENGTH

# Let's implement a decoder based on unbinding and closest match:

function decode(hv)
    return [
        centimeters[similarity.(Ref(hv * SEPALLENGTH), centimeters_hvs) |> argmax],
        centimeters[similarity.(Ref(hv * SEPALWIDTH), centimeters_hvs) |> argmax],
        centimeters[similarity.(Ref(hv * PETALLENGTH), centimeters_hvs) |> argmax],
        centimeters[similarity.(Ref(hv * PETALWIDTH), centimeters_hvs) |> argmax],
    ]
end

# # Training a small model

unique(y)

#

SETOSA = bundle(flower_hvs[vec(y) .== "Iris-setosa"])
VERSICOLOR = bundle(flower_hvs[vec(y) .== "Iris-versicolor"])
VIRGINICA = bundle(flower_hvs[vec(y) .== "Iris-virginica"])

# Let's decode each of this representations and compare them against the mean values of each
# class:

[decode(SETOSA)'; median(X[:, vec(y) .== "Iris-setosa"], dims = 2)']

#

[decode(VERSICOLOR)'; median(X[:, vec(y) .== "Iris-versicolor"], dims = 2)']

#

[decode(VIRGINICA)'; median(X[:, vec(y) .== "Iris-virginica"], dims = 2)']
