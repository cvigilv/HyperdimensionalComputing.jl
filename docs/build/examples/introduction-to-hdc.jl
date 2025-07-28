# # Introduction to Hyperdimensional Computing with HyperdimensionalComputing.jl
#
# ## Introduction
#
# Hyperdimensional Computing (HDC) is a brain-inspired computational paradigm that represents
# and manipulates information using high-dimensional vectors called **hypervectors**. These
# vectors typically have thousands of dimensions (often 1,000-10,000), making them
# "hyperdimensional."
#
# The key insight is that high-dimensional spaces have unique mathematical properties that allow
# for robust, fault-tolerant computation. Think of it like having a vast library where each book
# (hypervector) has so many pages that even if you change a few pages, you can still identify
# which book it is.
#
# Rather than the specific choice of the values in the hyperdimensional representations, we
# identify 4 hallmarks that distinguish hyperdimensional computing from other approaches:
#
# 1. **Hyperdimensional**: The HVs live in a very high-dimensional space, large enough such that
# random components can be seen as distinct and dissimilar from one another;
# 2. **Homogeneous**: The vast majority of HVs all have highly similar properties: they have
# (approximately) the same norm, are all equally (dis)similar to one another, and have the same
# dimensionality, even if they embed more complex information;
# 3. **Holographic**: The information encoded in an HV is distributed over its many dimensions;
# no specific region is more informative than another for a specific piece of information;
# 4. **Robust**: Randomly changing a modest number of the components does not substantially change
# an HV's meaning.
#
# The basic operations needed for HDC are remarkably simple. They hinge on 4 operations to
# manipulate and extract the information in the HVs:
#
# - Generating new HVs from scratch;
# - Combining a set of HVs into a new HV that is similar to all;
# - Using one or more HVs to generate a new one that is dissimilar to its parent(s);
# - Comparing 2 HVs to detect whether they are more (dis)similar than expected by chance.
#
# ## 1. Hypervector Creation
#
# ### Bipolar Hypervectors
#
# In this tutorial, we'll focus on **bipolar hypervectors** - vectors containing only -1s and
# +1s. A typical bipolar hypervector has dimension $D$ (e.g., $D = 10,000$) where each element
# is randomly assigned:
#
# $$\mathbf{h} \in \{-1,+1\}^D$$
#
# For example, a 8-dimensional bipolar hypervector might look like:
# $$\mathbf{h} = [+1, -1, +1, +1, -1, -1, +1, -1]$$
#
# To generate a bipolar hypervector with HyperdimensionalComputing.jl package, you can do the
# following:

using HyperdimensionalComputing

h = BipolarHDV()

# This will create a random vector of -1s and +1s of 10.000 dimensions.
#
# ### Key Properties
#
# **Quasi-orthogonality**: Randomly generated bipolar hypervectors are approximately orthogonal
# to each other. In high dimensions, the probability that two random bipolar vectors are similar
# becomes vanishingly small - like finding two identical snowflakes.
#
# **Distance Preservation**: The cosine similarity between random bipolar hypervectors follows
# a normal distribution centered around 0.
#
# ## 2. Fundamental Operations
#
# HDC uses three primary operations that preserve the hyperdimensional properties:
#
# ### 2.1 Bundling (Superposition)
#
# **Bundling** combines multiple hypervectors to create a summary vector that contains information from all inputs. Think of it as creating a "blend" that retains traces of all ingredients.
#
# For bipolar vectors, bundling uses **majority voting**:
#
# $$\text{Bundle}(\mathbf{h_1}, \mathbf{h_2}, ..., \mathbf{h_n})_i = \begin{cases}
# +1 & \text{if } \sum_{j=1}^{n} h_{j,i} > 0 \\
# -1 & \text{otherwise}
# \end{cases}$$
#
# **Example**: Bundling three 8-dimensional vectors:
# - $\mathbf{a} = [+1, -1, +1, +1, -1, -1, +1, -1]$
# - $\mathbf{b} = [-1, +1, +1, -1, +1, -1, +1, +1]$
# - $\mathbf{c} = [+1, +1, -1, +1, -1, +1, +1, -1]$
#
# Result: $\text{Bundle}(\mathbf{a}, \mathbf{b}, \mathbf{c}) = [+1, +1, +1, +1, -1, -1, +1, -1]$
#
# In HyperdimensionalComputing.jl, this is done as follows:

h₁ = BipolarHDV([ 1, -1,  1,  1, -1, -1,  1, -1])
h₂ = BipolarHDV([-1,  1,  1, -1,  1, -1,  1,  1])
h₃ = BipolarHDV([ 1,  1, -1,  1, -1,  1,  1, -1])
aggregate([h₁, h₂, h₃])

# You can also do the same using the `+` operator:

h₁ + h₂ + h₃

# ### 2.2 Binding
#
# **Binding** creates associations between hypervectors, similar to forming key-value pairs. The
# bound result is dissimilar to both inputs, but can be "unbound" using one input to retrieve the
# other.
#
# For bipolar vectors, binding uses **element-wise multiplication**:
#
# $$\text{Bind}(\mathbf{a}, \mathbf{b}) = \mathbf{a} \odot \mathbf{b}$$
#
# **Example**:
# - $\mathbf{a} = [+1, -1, +1, +1, -1, -1, +1, -1]$
# - $\mathbf{b} = [-1, +1, +1, -1, +1, -1, +1, +1]$
# - $\mathbf{a} \odot \mathbf{b} = [-1, -1, +1, -1, -1, +1, +1, -1]$
#
# In HyperdimensionalComputing.jl, binding can be done using the `bind` function: `*` operators:

bound = bind([h₁, h₂])

# or the `*` operator:

h₁ * h₂

# **Unbinding**: Since element-wise multiplication is its own inverse for bipolar vectors,
# $(\mathbf{a} \odot \mathbf{b}) \odot \mathbf{a} = \mathbf{b}$, we can unbind information from
# a hypervector as follows:

retrieved = bound * h₁

#

h₂ == retrieved

# ### 2.3 Shifting/Permutation
#
# **Shifting** (or permutation) creates new hypervectors that are orthogonal to the original
# while preserving structure. It's like rearranging the elements according to a fixed pattern.
#
# For bipolar vectors, a common approach is **circular shifting**:
#
# $$\text{Shift}(\mathbf{h}, k)_i = h_{(i-k) \bmod D}$$
#
# **Example** with right shift by 2:
# - Original: $[+1, -1, +1, +1, -1, -1, +1, -1]$
# - Shifted: $[+1, -1, +1, -1, +1, +1, -1, -1]$
# 
# In HyperdimensionalComputing.jl, this is done with the `Π` (`\Pi`) operator:
#

Π(h₁, 2)

# ### 2.4 Similarity Measurement
#
# For classification and retrieval, we measure similarity using **cosine similarity** for bipolar
# vectors:
#
# $$\text{Similarity}(\mathbf{a}, \mathbf{b}) = \frac{\mathbf{a} \cdot \mathbf{b}}{|\mathbf{a}||\mathbf{b}|} = \frac{\mathbf{a} \cdot \mathbf{b}}{D}$$
#
# Since bipolar vectors have unit magnitude ($|\mathbf{h}| = \sqrt{D}$), the cosine similarity
# simplifies to the normalized dot product:
#
# $\text{Similarity}(\mathbf{a}, \mathbf{b}) = \frac{\mathbf{a} \cdot \mathbf{b}}{D}$

sim = similarity(h₁, h₂)

# ## 3. Encoding Data as Hypervectors
#
# The true power of HDC emerges when we combine the fundamental operations to encode complex data
# structures as hypervectors. By creatively applying bundling, binding, and shifting, we can
# represent virtually any type of information - from sequences and hierarchies to graphs and
# associative memories. The operations act as building blocks that can be composed in countless
# ways, limited only by our imagination and the specific requirements of our application. Let's
# explore two fundamental encoding strategies that demonstrate this flexibility.
#
# ### 3.1 N-gram Encoding
#
# **N-grams** represent sequences by encoding the order of elements. This is particularly useful for text processing where word order matters.
#
# **Approach**:
# 1. Assign a unique hypervector to each symbol
# 2. Use shifting to represent position
# 3. Bundle all positions to create the n-gram
#
# **Mathematical formulation** for trigram "ABC":
#
# $$\mathbf{trigram} = \mathbf{A} \odot \text{Shift}(\mathbf{B}, 1) \odot \text{Shift}(\mathbf{C}, 2)$$
#
# **Example**: For the word "CAT":
# - Bigrams: "CA", "AT"
# - $\mathbf{CA} = \mathbf{C} \odot \text{Shift}(\mathbf{A}, 1)$
# - $\mathbf{AT} = \mathbf{A} \odot \text{Shift}(\mathbf{T}, 1)$
# - Word representation: $\text{Bundle}(\mathbf{CA}, \mathbf{AT})$

# function encode_ngrams(text::String, n::Int, dimension::Int=1000)
#     # Create symbol dictionary
#     symbols = Dict{Char, Vector{Int}}()
#     for char in unique(text)
#         symbols[char] = random_bipolar_vector(dimension)
#     end
#
#     # Generate n-grams
#     ngram_vectors = Vector{Vector{Int}}()
#
#     for i in 1:(length(text) - n + 1)
#         ngram = text[i:i+n-1]
#         ngram_vector = symbols[ngram[1]]
#
#         for j in 2:length(ngram)
#             shifted = ∏(symbols[ngram[j]], j-1)
#             ngram_vector = bind(ngram_vector, shifted)
#         end
#
#         push!(ngram_vectors, ngram_vector)
#     end
#
#     return bundle(ngram_vectors)
# end
#
# # Create n-gram encoding for a sequence
# word_vector = encode_ngrams("CAT", 2)
# println("Encoded 'CAT' with bigrams, vector length: ", length(word_vector))

# ### 3.2 Hash Table Encoding

# **Hash tables** in HDC map keys to values using binding, creating associative memories that can handle noise and incomplete queries.

# **Construction**:
# 1. For each key-value pair $(k_i, v_i)$, create $\mathbf{k_i} \odot \mathbf{v_i}$
# 2. Bundle all bound pairs: $\mathbf{M} = \text{Bundle}(\mathbf{k_1} \odot \mathbf{v_1}, \mathbf{k_2} \odot \mathbf{v_2}, ...)$

# **Retrieval**: To query key $\mathbf{q}$, compute $\mathbf{M} \odot \mathbf{q}$ and find the closest stored value.

# **Example**: Storing animal-sound associations:
# - Store: ("dog", "bark"), ("cat", "meow"), ("cow", "moo")
# - Memory: $\mathbf{M} = \text{Bundle}(\mathbf{dog} \odot \mathbf{bark}, \mathbf{cat} \odot \mathbf{meow}, \mathbf{cow} \odot \mathbf{moo})$
# - Query "dog": $\mathbf{M} \odot \mathbf{dog} \approx \mathbf{bark}$

# function create_hash_table(key_value_pairs::Vector{Tuple{String, String}}, dimension::Int=1000)
#     # Create symbol dictionaries
#     keys = Dict{String, Vector{Int}}()
#     values = Dict{String, Vector{Int}}()
#
#     for (k, v) in key_value_pairs
#         if !haskey(keys, k)
#             keys[k] = random_bipolar_vector(dimension)
#         end
#         if !haskey(values, v)
#             values[v] = random_bipolar_vector(dimension)
#         end
#     end
#
#     # Create bound pairs and bundle them
#     bound_pairs = [bind(keys[k], values[v]) for (k, v) in key_value_pairs]
#     memory = bundle(bound_pairs)
#
#     return (memory, keys, values)
# end
#
# function query_hash_table(memory::Vector{Int}, query_key::Vector{Int}, values::Dict{String, Vector{Int}})
#     # Unbind with query key
#     result = bind(memory, query_key)
#
#     # Find most similar value
#     best_match = ""
#     best_similarity = -Inf
#
#     for (value_name, value_vector) in values
#         sim = cosine_similarity(result, value_vector)
#         if sim > best_similarity
#             best_similarity = sim
#             best_match = value_name
#         end
#     end
#
#     return best_match, best_similarity
# end
#
# # Create and query HDC hash table
# key_value_pairs = [("dog", "bark"), ("cat", "meow"), ("cow", "moo")]
# memory, keys, values = create_hash_table(key_value_pairs)
#
# # Query the hash table
# result, similarity = query_hash_table(memory, keys["dog"], values)
# println("Query 'dog' result: ", result, " (similarity: ", similarity, ")")

# ## 4. Basic Learning via Prototype Generation

# ### 4.1 Sum-All-Hypervectors Approach

# The simplest learning method creates **class prototypes** by bundling all training examples belonging to each class.

# **Algorithm**:
# 1. For each class $c$, bundle all training examples: $\mathbf{P_c} = \text{Bundle}(\mathbf{x_1}, \mathbf{x_2}, ..., \mathbf{x_n})$ where $\mathbf{x_i} \in c$
# 2. For classification, compute similarity between test example and each prototype
# 3. Assign to the most similar class

# **Language Detection Example**:
# - English prototype: Bundle all English text hypervectors
# - Spanish prototype: Bundle all Spanish text hypervectors
# - French prototype: Bundle all French text hypervectors

# function train_prototypes(training_data::Dict{String, Vector{Vector{Int}}})
#     prototypes = Dict{String, Vector{Int}}()
#
#     for (language, examples) in training_data
#         prototypes[language] = bundle(examples)
#     end
#
#     return prototypes
# end
#
# function classify_text(test_vector::Vector{Int}, prototypes::Dict{String, Vector{Int}})
#     best_language = ""
#     best_similarity = -Inf
#
#     for (language, prototype) in prototypes
#         sim = cosine_similarity(test_vector, prototype)
#         if sim > best_similarity
#             best_similarity = sim
#             best_language = language
#         end
#     end
#
#     return best_language, best_similarity
# end
#
# # Example with simulated language data
# english_examples = [random_bipolar_vector(1000) for _ in 1:10]
# spanish_examples = [random_bipolar_vector(1000) for _ in 1:10]
# french_examples = [random_bipolar_vector(1000) for _ in 1:10]
#
# training_data = Dict(
#     "English" => english_examples,
#     "Spanish" => spanish_examples,
#     "French" => french_examples
# )
#
# # Train prototypes for each language
# prototypes = train_prototypes(training_data)
#
# # Classify new text
# test_text = random_bipolar_vector(1000)
# predicted_language, similarity = classify_text(test_text, prototypes)
# println("Predicted language: ", predicted_language, " (similarity: ", similarity, ")")

# ## Summary

# Hyperdimensional Computing provides a robust framework for representing and processing information using high-dimensional bipolar vectors. The three fundamental operations (bundling, binding, and shifting) enable complex computations while maintaining interpretability and fault tolerance. Through encodings like n-grams and hash tables, HDC can handle structured data, while learning algorithms enable adaptive classification systems that improve with experience.

# The power of HDC lies in its simplicity: using only basic operations on bipolar vectors, it can solve complex problems in machine learning, natural language processing, and cognitive computing while remaining transparent and interpretable.
