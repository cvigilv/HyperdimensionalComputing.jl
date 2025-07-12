# # HyperdimensionalComputing.jl Tutorial
#
# This tutorial introduces the core concepts of hyperdimensional computing using the HyperdimensionalComputing.jl package.
# We'll cover creating hypervectors, performing operations on them, and encoding various data structures.

using HyperdimensionalComputing

# ## 1. Creating Hypervectors
#
# Hyperdimensional vectors (HDVs) are high-dimensional vectors that form the foundation of hyperdimensional computing.
# The package provides several types of hypervectors, each with different characteristics.

# ### 1.1 Bipolar Hypervectors
# 
# BipolarHDV contains values of -1 and 1, making them suitable for many HD computing applications.

# Create a bipolar hypervector with default dimension (10,000)
bipolar_hdv = BipolarHDV()
println("Bipolar HDV size: ", size(bipolar_hdv))
println("First 10 elements: ", bipolar_hdv.v[1:10])

# Create a bipolar hypervector with custom dimension
small_bipolar = BipolarHDV(100)
println("Small bipolar HDV size: ", size(small_bipolar))

# ### 1.2 Binary Hypervectors
#
# BinaryHDV contains values of 0 and 1, useful for binary operations.

binary_hdv = BinaryHDV(1000)
println("Binary HDV first 10 elements: ", binary_hdv.v[1:10])

# ### 1.3 Real-valued Hypervectors
#
# RealHDV contains real values drawn from a normal distribution.

real_hdv = RealHDV(1000)
println("Real HDV first 10 elements: ", real_hdv.v[1:10])

# ### 1.4 Graded Hypervectors
#
# GradedBipolarHDV and GradedHDV allow for graded relationships with values in continuous ranges.

graded_bipolar = GradedBipolarHDV(Float32, 1000)
println("Graded bipolar HDV first 10 elements: ", graded_bipolar.v[1:10])

graded_hdv = GradedHDV(Float32, 1000)
println("Graded HDV first 10 elements: ", graded_hdv.v[1:10])

# ## 2. Operations over Hypervectors
#
# Hyperdimensional computing relies on three fundamental operations: bundling (aggregation), 
# binding, and shifting (permutation).

# ### 2.1 Bundling/Aggregation
#
# Bundling combines multiple vectors into a single vector that is similar to all input vectors.
# This is useful for creating superposition representations.

# Create some sample vectors
hdv1 = BipolarHDV(100)
hdv2 = BipolarHDV(100) 
hdv3 = BipolarHDV(100)

# Bundle vectors using the + operator
bundled = hdv1 + hdv2
println("Bundled vector size: ", size(bundled))

# Bundle multiple vectors using aggregate
multi_bundled = aggregate([hdv1, hdv2, hdv3])
println("Multi-bundled vector size: ", size(multi_bundled))

# ### 2.2 Binding
#
# Binding combines vectors to create a new vector that is dissimilar to both inputs.
# This operation is used to associate different pieces of information.

# Bind two vectors using the * operator
bound = hdv1 * hdv2
println("Bound vector size: ", size(bound))

# Bind multiple vectors
multi_bound = bind([hdv1, hdv2, hdv3])
println("Multi-bound vector size: ", size(multi_bound))

# ### 2.3 Shifting (Permutation)
#
# Shifting performs cyclic permutation of vector elements, which is useful for encoding sequences.

# Shift vector by 5 positions
shifted = Π(hdv1, 5)
println("Shifted vector has same size: ", size(shifted) == size(hdv1))

# In-place shifting
Π!(hdv1, 3)
println("In-place shifted vector offset: ", hdv1.offset)

# ### 2.4 Similarity Measurement
#
# We can measure similarity between vectors to determine how related they are.

# Create two similar vectors (one is a shifted version of the other)
base_vector = BipolarHDV(1000)
shifted_vector = Π(base_vector, 1)
random_vector = BipolarHDV(1000)

# Calculate similarities
sim_shifted = similarity(base_vector, shifted_vector)
sim_random = similarity(base_vector, random_vector)

println("Similarity with shifted version: ", sim_shifted)
println("Similarity with random vector: ", sim_random)

# ## 3. Encoding Structures
#
# Now we'll explore how to encode different data structures using hypervectors.

# ### 3.1 Encoding Sets
#
# Sets can be encoded by bundling the hypervectors representing each element.

# Create a vocabulary of elements
vocabulary = ['a', 'b', 'c', 'd', 'e']
element_hdvs = Dict(char => BipolarHDV(1000) for char in vocabulary)

# Encode a set {a, c, e}
set1 = ['a', 'c', 'e']
set1_encoding = aggregate([element_hdvs[char] for char in set1])

# Encode another set {b, c, d}
set2 = ['b', 'c', 'd']
set2_encoding = aggregate([element_hdvs[char] for char in set2])

# Check similarity (should be low since sets have little overlap)
set_similarity = similarity(set1_encoding, set2_encoding)
println("Similarity between sets {a,c,e} and {b,c,d}: ", set_similarity)

# Encode a more similar set {a, c, d}
set3 = ['a', 'c', 'd']
set3_encoding = aggregate([element_hdvs[char] for char in set3])
set3_similarity = similarity(set1_encoding, set3_encoding)
println("Similarity between sets {a,c,e} and {a,c,d}: ", set3_similarity)

# ### 3.2 Encoding Key-Value Pairs
#
# Key-value pairs can be encoded by binding the key and value vectors, then bundling multiple pairs.

# Create vocabulary for keys and values
keys = ["name", "age", "city"]
values = ["Alice", "25", "Boston", "Bob", "30", "Chicago"]

# Create hypervectors for keys and values
key_hdvs = Dict(k => BipolarHDV(1000) for k in keys)
value_hdvs = Dict(v => BipolarHDV(1000) for v in values)

# Encode a record: {name: Alice, age: 25, city: Boston}
record1_pairs = [
    key_hdvs["name"] * value_hdvs["Alice"],
    key_hdvs["age"] * value_hdvs["25"],
    key_hdvs["city"] * value_hdvs["Boston"]
]
record1_encoding = aggregate(record1_pairs)

# Encode another record: {name: Bob, age: 30, city: Chicago}
record2_pairs = [
    key_hdvs["name"] * value_hdvs["Bob"],
    key_hdvs["age"] * value_hdvs["30"],
    key_hdvs["city"] * value_hdvs["Chicago"]
]
record2_encoding = aggregate(record2_pairs)

# Check similarity between records
record_similarity = similarity(record1_encoding, record2_encoding)
println("Similarity between records: ", record_similarity)

# Query a record: What's the name in record1?
# We bind the record with the key to retrieve the value
name_query = record1_encoding * key_hdvs["name"]
name_similarity_alice = similarity(name_query, value_hdvs["Alice"])
name_similarity_bob = similarity(name_query, value_hdvs["Bob"])

println("Name query similarity with Alice: ", name_similarity_alice)
println("Name query similarity with Bob: ", name_similarity_bob)

# ### 3.3 Encoding Strings
#
# Strings can be encoded using n-grams, which capture local sequential patterns.

# Create character vocabulary
chars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 
         'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' ']
char_hdvs = Dict(c => BipolarHDV(1000) for c in chars)

# Compute 3-grams for encoding strings
trigrams = compute_3_grams(char_hdvs)
println("Trigram embedding order: ", order(trigrams))

# Encode some strings
string1 = "hello world"
string2 = "hello there"
string3 = "goodbye world"

# Convert strings to character arrays
seq1 = collect(string1)
seq2 = collect(string2)
seq3 = collect(string3)

# Encode strings using trigrams
encoding1 = sequence_embedding(seq1, trigrams)
encoding2 = sequence_embedding(seq2, trigrams)
encoding3 = sequence_embedding(seq3, trigrams)

# Check similarities
sim_hello = similarity(encoding1, encoding2)  # Both start with "hello"
sim_world = similarity(encoding1, encoding3)  # Both end with "world"
sim_different = similarity(encoding2, encoding3)  # Quite different

println("Similarity 'hello world' vs 'hello there': ", sim_hello)
println("Similarity 'hello world' vs 'goodbye world': ", sim_world)
println("Similarity 'hello there' vs 'goodbye world': ", sim_different)

# ### 3.4 Basic Learning Example
#
# We can use the encoded vectors for simple classification tasks.

# Create training data
training_strings = ["apple banana", "banana cherry", "cherry date", "date elderberry"]
training_labels = ["fruit_pair_1", "fruit_pair_2", "fruit_pair_3", "fruit_pair_4"]

# Encode training strings
training_encodings = [sequence_embedding(collect(s), trigrams) for s in training_strings]

# Train a simple classifier
centers = train(training_labels, training_encodings)
println("Trained centers for classes: ", keys(centers))

# Test on new data
test_string = "apple cherry"  # Similar to training examples
test_encoding = sequence_embedding(collect(test_string), trigrams)

# Make prediction
prediction = predict(test_encoding, centers)
println("Prediction for 'apple cherry': ", prediction)

# ## Conclusion
#
# This tutorial covered the basics of hyperdimensional computing with HyperdimensionalComputing.jl:
# 
# 1. **Creating hypervectors**: Different types (Bipolar, Binary, Real, Graded) for different applications
# 2. **Operations**: Bundling for superposition, binding for association, shifting for sequences
# 3. **Encoding structures**: Sets through bundling, key-value pairs through binding+bundling, strings through n-grams
#
# Hyperdimensional computing provides a powerful framework for representing and manipulating 
# high-dimensional symbolic data, with applications in machine learning, cognitive architectures, 
# and neuromorphic computing.
