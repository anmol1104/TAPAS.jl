struct Node
    v::Int64                                # Node value
    T::Vector{Int64}                        # Predecessor nodes (tail node values)
    H::Vector{Int64}                        # Successor nodes (head node values)
end

struct Origin
    n::Node                                 # Origin node
    k::Int64                                # Origin node index in vector G.O; k = findfirst(x -> (x == o), O)
    S::Vector{Node}                         # Vector of destination nodes
    Q::Vector{Float64}                      # Vector of flows   
    Lᵖ::Vector{Int64}                       # Predecessor label
end

mutable struct Arc
    t::Node                                 # Tail node (From)
    h::Node                                 # Head node (To)
    V::Float64                              # Volume capacity of the arc
    d::Float64                              # Length of the arc
    tₒ::Float64                             # Free flow travel time on the arc
    α::Float64                              # BPR parameter
    β::Float64                              # BPR parameter
    xʳ::Vector{Float64}                     # Origin based arc flow
    c::Float64                              # Arc cost
    c′::Float64                             # Arc cost derivative
    ϕ::Bool                                 # Assignment boolean (UE => ϕ = false; SO => ϕ = true)
end

struct PAS
    e₁::Vector{Arc}                         # First segment
    e₂::Vector{Arc}                         # Second segment
    o::Origin                               # Assosciated origin
end

struct Graph
    name::String                            # Network name
    N::Vector{Node}                         # Vector of nodes 
    A::Vector{Arc}                          # Vector of arcs
    K::Dict{Tuple{Int64, Int64}, Int64}     # Collection of arc indices mapped to tuple of arc head and tail node value (one to one mapping - (i,j) => findfirst(x -> (x == (i,j)), [(a.t.v, a.h.v) for a in A]))
    O::Vector{Origin}                       # Vector of origins
end

function Base.:∈(pₒ::PAS, P::Vector{PAS})
    for p in P if pₒ.e₁ == p.e₁ && pₒ.e₂ == p.e₂ return true end end
    return false
end
Base.:∉(pₒ::PAS, P::Vector{PAS}) = !(Base.:∈(pₒ, P))