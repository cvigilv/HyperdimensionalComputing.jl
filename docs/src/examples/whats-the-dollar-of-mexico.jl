# # What We Mean When We Say "What's the Dollar of Mexico?": Replicating Kanerva's Concept Mapping
#
# In 2010, Pentti Kanerva published a fascinating paper that explored how our brains might 
# perform analogical reasoning using high-dimensional vector spaces. The paper's title comes 
# from a deceptively simple question: "What's the dollar of Mexico?" — which we immediately 
# understand to mean "peso," even though Mexico doesn't literally have a "dollar."
#
# This kind of analogical thinking is so natural to us that we barely notice it, yet it 
# reveals something profound about how our minds work. Today, we'll replicate Kanerva's key 
# insights using Julia's HyperdimensionalComputing.jl package, showing how high-dimensional 
# vectors can encode concepts and perform the kinds of mappings that enable analogical reasoning.

# ## The Big Picture: Why High-Dimensional Vectors?
#
# Traditional computing works with small, precise representations — bytes, words, maybe 32 or 64 bits. 
# But Kanerva argues that brain-like computing requires something fundamentally different: 
# **hyperdimensional vectors** with tens of thousands of dimensions. These vectors have remarkable 
# properties that make them suitable for modeling how we think about concepts and their relationships.

using HyperdimensionalComputing
using Random
Random.seed!(42)  # For reproducible results

# We'll work with 10,000-dimensional binary vectors, just like Kanerva's paper
const DIM = 10000

println("Working with $(DIM)-dimensional hyperdimensional vectors")

# ## The Two Fundamental Operations
#
# Kanerva identifies two key operations that make hyperdimensional computing possible:
#
# 1. **Binding** (★): Combines two vectors to create something dissimilar to both
# 2. **Bundling** ([...+...]): Combines multiple vectors to create their "average"
#
# In our Julia implementation, these correspond to multiplication (*) and addition (+):

# Create some basic concept vectors
function create_concept(name::String)
    return BipolarHDV(DIM)
end

# Let's create vectors for countries and their attributes
usa_vec = create_concept("USA")
mexico_vec = create_concept("Mexico")
sweden_vec = create_concept("Sweden")

# Attributes
name_vec = create_concept("NAME")
capital_vec = create_concept("CAPITAL")
currency_vec = create_concept("CURRENCY")

# Specific values
washington_vec = create_concept("Washington")
mexico_city_vec = create_concept("Mexico City")
stockholm_vec = create_concept("Stockholm")
dollar_vec = create_concept("Dollar")
peso_vec = create_concept("Peso")
krona_vec = create_concept("Krona")

println("Created concept vectors for countries, attributes, and values")

# ## Holistic Encoding: Representing Complex Concepts
#
# The magic happens when we combine these vectors to represent complex concepts. A country 
# isn't just a name — it's a bundle of attributes like capital city, currency, culture, etc. 
# We can encode this holistically:

# Encode the United States as a holistic vector
# US = (NAME * USA) + (CAPITAL * Washington) + (CURRENCY * Dollar)
us_encoded = (name_vec * usa_vec) + (capital_vec * washington_vec) + (currency_vec * dollar_vec)
println("US encoded vector size: ", size(us_encoded))

# Encode Mexico similarly
mexico_encoded = (name_vec * mexico_vec) + (capital_vec * mexico_city_vec) + (currency_vec * peso_vec)

# And Sweden
sweden_encoded = (name_vec * sweden_vec) + (capital_vec * stockholm_vec) + (currency_vec * krona_vec)

println("Encoded three countries with their attributes")

# The beautiful property of this encoding is that we can extract information from it:

# What's the currency of the US?
# We "query" by binding with the currency attribute
us_currency_query = us_encoded * currency_vec
println("\nQuerying: What's the currency of the US?")
println("Similarity to dollar: ", round(similarity(us_currency_query, dollar_vec), digits=3))
println("Similarity to peso: ", round(similarity(us_currency_query, peso_vec), digits=3))
println("Similarity to krona: ", round(similarity(us_currency_query, krona_vec), digits=3))

# ## The Heart of the Matter: Mapping Between Concept Spaces
#
# Now comes the really interesting part. Kanerva shows that we can create **mapping vectors** 
# that transform one concept space into another. This is how we can answer "What's the dollar of Mexico?"

# Create a mapping from US to Mexico
us_to_mexico_map = us_encoded * mexico_encoded

println("\nCreated mapping vector from US to Mexico")
println("Map vector size: ", size(us_to_mexico_map))

# Now we can use this mapping to answer our question
# "What's the dollar of Mexico?"
dollar_mapped = dollar_vec * us_to_mexico_map

println("\nWhat's the dollar of Mexico?")
println("Similarity to peso: ", round(similarity(dollar_mapped, peso_vec), digits=3))
println("Similarity to dollar: ", round(similarity(dollar_mapped, dollar_vec), digits=3))
println("Similarity to krona: ", round(similarity(dollar_mapped, krona_vec), digits=3))

# The mapping vector captures the relationship between the US and Mexico, and when we apply it to "dollar," we get "peso"!

# ## The IQ Test: "United States is to Mexico as Dollar is to what?"
#
# Let's implement Kanerva's famous IQ test example more explicitly:

# The classic analogy: "United States is to Mexico as Dollar is to what?"
# This is asking: US : Mexico :: Dollar : ?

# We can solve this by finding the mapping that takes US to Mexico
# and then applying it to Dollar

# Method 1: Direct computation as shown in the paper
# If F maps Dollar to US, then F also maps Peso to Mexico
# So: F * Dollar = US and F * Peso = Mexico
# This gives us: US * Dollar = Mexico * Peso
# Therefore: Mexico * US * Dollar = Peso

answer1 = mexico_encoded * us_encoded * dollar_vec
println("\nIQ Test Answer (Method 1 - Direct computation):")
println("Similarity to peso: ", round(similarity(answer1, peso_vec), digits=3))
println("Similarity to dollar: ", round(similarity(answer1, dollar_vec), digits=3))
println("Similarity to krona: ", round(similarity(answer1, krona_vec), digits=3))

# Method 2: Using the mapping vector we computed earlier
answer2 = dollar_vec * us_to_mexico_map
println("\nIQ Test Answer (Method 2 - Using mapping vector):")
println("Similarity to peso: ", round(similarity(answer2, peso_vec), digits=3))
println("Similarity to dollar: ", round(similarity(answer2, dollar_vec), digits=3))
println("Similarity to krona: ", round(similarity(answer2, krona_vec), digits=3))

# ## Chaining Mappings: From Swedish to English to Spanish
#
# One of the most elegant aspects of Kanerva's approach is that mappings can be chained. 
# We can translate concepts from Swedish to English to Spanish:

# Create mapping from Sweden to US
sweden_to_us_map = sweden_encoded * us_encoded

# Chain the mappings: Sweden -> US -> Mexico
sweden_to_mexico_map = sweden_to_us_map * us_to_mexico_map

# This should be equivalent to the direct mapping
direct_sweden_to_mexico = sweden_encoded * mexico_encoded

println("\nChained mapping similarity to direct mapping: ")
println(round(similarity(sweden_to_mexico_map, direct_sweden_to_mexico), digits=3))

# Test the chained mapping
krona_to_peso = krona_vec * sweden_to_mexico_map
println("\nWhat's the krona of Mexico (via US)?")
println("Similarity to peso: ", round(similarity(krona_to_peso, peso_vec), digits=3))
println("Similarity to dollar: ", round(similarity(krona_to_peso, dollar_vec), digits=3))
println("Similarity to krona: ", round(similarity(krona_to_peso, krona_vec), digits=3))

# ## The Deeper Implications
#
# What we've demonstrated here is remarkable: using simple vector operations on high-dimensional spaces, we can:
#
# 1. **Encode complex concepts** holistically
# 2. **Extract specific information** from these encodings
# 3. **Create mappings** between different concept spaces
# 4. **Perform analogical reasoning** through vector arithmetic
# 5. **Chain mappings** to traverse multiple concept spaces
#
# The key insight is that the high dimensionality gives us the space we need for these operations 
# to work reliably. In low-dimensional spaces, the noise would overwhelm the signal, but in 10,000 
# dimensions, the geometric properties work in our favor.

# ## From Variables to Prototypes
#
# One of Kanerva's most profound observations is about how this differs from traditional symbolic AI. 
# Instead of using abstract variables, we use **prototypes** — concrete examples that serve as templates 
# for understanding new situations. When we ask "What's the dollar of Mexico?", we're not using an 
# abstract concept of "currency"; we're using the specific dollar as a prototype to understand peso.

# Let's demonstrate this with a more complex example
function create_country_profile(name, capital, currency, population, continent)
    name_attr = create_concept("NAME")
    capital_attr = create_concept("CAPITAL")
    currency_attr = create_concept("CURRENCY")
    population_attr = create_concept("POPULATION")
    continent_attr = create_concept("CONTINENT")
    
    return (name_attr * create_concept(name)) + 
           (capital_attr * create_concept(capital)) + 
           (currency_attr * create_concept(currency)) + 
           (population_attr * create_concept(population)) + 
           (continent_attr * create_concept(continent))
end

# Create rich country profiles
france = create_country_profile("France", "Paris", "Euro", "Large", "Europe")
japan = create_country_profile("Japan", "Tokyo", "Yen", "Large", "Asia")
brazil = create_country_profile("Brazil", "Brasilia", "Real", "Large", "South America")

println("\nCreated rich country profiles with multiple attributes")

# Create a mapping from France to Japan
france_to_japan_map = france * japan

# What's the Euro of Japan?
euro_concept = create_concept("Euro")
euro_mapped_to_japan = euro_concept * france_to_japan_map
yen_concept = create_concept("Yen")

println("\nWhat's the Euro of Japan?")
println("Similarity to Yen: ", round(similarity(euro_mapped_to_japan, yen_concept), digits=3))

# ## Demonstrating Robustness: Multiple Analogies
#
# Let's test our system with multiple analogies to show its robustness:

# Test multiple currency analogies
println("\n=== Testing Multiple Currency Analogies ===")

# France to Japan currency mapping
france_currency_query = france * currency_vec
japan_currency_query = japan * currency_vec

println("France currency similarity to Euro: ", round(similarity(france_currency_query, euro_concept), digits=3))
println("Japan currency similarity to Yen: ", round(similarity(japan_currency_query, yen_concept), digits=3))

# Cross-mapping test: What's the Yen of France?
yen_mapped_to_france = yen_concept * (japan * france)
println("What's the Yen of France?")
println("Similarity to Euro: ", round(similarity(yen_mapped_to_france, euro_concept), digits=3))

# ## Exploring the Geometric Properties
#
# One of the key insights from Kanerva's work is that these operations preserve certain geometric 
# properties. Let's explore this:

# Check that binding preserves distances
test_vec1 = create_concept("Test1")
test_vec2 = create_concept("Test2")
binding_vec = create_concept("Binder")

original_similarity = similarity(test_vec1, test_vec2)
bound_similarity = similarity(test_vec1 * binding_vec, test_vec2 * binding_vec)

println("\n=== Geometric Properties ===")
println("Original similarity: ", round(original_similarity, digits=3))
println("Similarity after binding: ", round(bound_similarity, digits=3))
println("Distance preservation: ", round(abs(original_similarity - bound_similarity), digits=3))

# ## The Computational Revolution
#
# This approach represents a fundamental shift in how we think about computation and cognition. 
# Instead of the rigid, symbolic representations of traditional AI, hyperdimensional computing 
# offers a more fluid, analogical approach that mirrors how humans naturally think.

# Let's demonstrate with a final complex example
println("\n=== Final Complex Example: Multi-level Analogies ===")

# Create a hierarchical concept structure
animal_attr = create_concept("ANIMAL")
habitat_attr = create_concept("HABITAT")
diet_attr = create_concept("DIET")

# Animals
lion_concept = create_concept("Lion")
shark_concept = create_concept("Shark")
eagle_concept = create_concept("Eagle")

# Habitats
land_concept = create_concept("Land")
ocean_concept = create_concept("Ocean")
sky_concept = create_concept("Sky")

# Diets
carnivore_concept = create_concept("Carnivore")

# Create animal profiles
lion_profile = (animal_attr * lion_concept) + (habitat_attr * land_concept) + (diet_attr * carnivore_concept)
shark_profile = (animal_attr * shark_concept) + (habitat_attr * ocean_concept) + (diet_attr * carnivore_concept)
eagle_profile = (animal_attr * eagle_concept) + (habitat_attr * sky_concept) + (diet_attr * carnivore_concept)

# Create analogical mappings
land_to_ocean_map = lion_profile * shark_profile
ocean_to_sky_map = shark_profile * eagle_profile

# Chain the mappings: What's the lion of the sky?
lion_of_sky = lion_concept * land_to_ocean_map * ocean_to_sky_map
direct_lion_to_eagle = lion_concept * (lion_profile * eagle_profile)

println("What's the lion of the sky (chained mapping)?")
println("Similarity to eagle: ", round(similarity(lion_of_sky, eagle_concept), digits=3))
println("Direct lion-to-eagle mapping similarity: ", round(similarity(direct_lion_to_eagle, eagle_concept), digits=3))

# ## Conclusion: The Future of Concept Representation
#
# Kanerva's work points toward a fundamentally different way of thinking about computation and cognition. 
# The HyperdimensionalComputing.jl package makes these ideas accessible and practical. As we've seen, 
# with just a few lines of code, we can:
#
# - Encode complex concepts holistically
# - Perform analogical reasoning through vector operations  
# - Create mappings between different domains of knowledge
# - Chain these mappings to traverse conceptual spaces
#
# This approach has profound implications for AI systems that need to understand and reason about 
# concepts in human-like ways. It suggests that the key to flexible, adaptive intelligence might 
# not be in building bigger symbolic knowledge bases, but in learning to work with the geometric 
# properties of high-dimensional spaces.

println("\n=== Summary ===")
println("Successfully demonstrated:")
println("✓ Holistic concept encoding")
println("✓ Analogical reasoning through vector operations")
println("✓ Concept mapping and chaining")
println("✓ Geometric property preservation")
println("✓ Multi-level analogical structures")
println("\nThe next time someone asks you 'What's the dollar of Mexico?', you'll know that")
println("your brain is performing sophisticated vector operations in a high-dimensional")
println("concept space — and thanks to Kanerva's insights and HyperdimensionalComputing.jl,")
println("we can now replicate some of that magic in our computers.")
