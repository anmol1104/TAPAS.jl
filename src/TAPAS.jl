module TAPAS

using CSV
using DataFrames
using StatsBase
using Dates
using Printf
using Plots

include("datastructure.jl")
include("build.jl")
include("func.jl")
include("TA.jl")

"""
    assigntraffic(network; assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:off)

Fukushima Frank-Wolfe method for traffic assignment.

# Returns
a named tuple with keys `:metadata`, `:report`, and `:output`
- `metadata::String`  : Text defining the traffic assignment run 
- `report::DataFrame` : A log of total network flow, total network cost, and run time for every iteration
- `output::DataFrame` : Flow and cost for every arc from the final iteration

# Arguments
- `network::String`         : Network
- `assignment::Symbol=:UE`  : Assignment type; one of `:UE`, `:SO`
- `tol::Float64=1e-5`       : Tolerance level for relative gap
- `maxiters::Int64=20`      : Maximum number of iterations
- `maxruntime::Int64=300`   : Maximum algorithm run time (seconds)
- `log::Symbol`             : Log iterations (one of `:off`, `:on`)
"""
function assigntraffic(network; assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:off)
    G = TAFW.build(network, assignment)
    return tapas(G, tol, maxiters, maxruntime, log)
    end
end

"""
    getrg(network, solution::DataFrame)

Returns relative gap for `network` given traffic assignment `solution`.
"""
function getrg(network, solution::DataFrame)
    G = build(network, :none)
    N, A, O, K = G.N, G.A, G.O, G.K
    
    for row in 1:nrow(solution)
        i = solution[row, :FROM]::Int64
        j = solution[row, :TO]::Int64
        x = solution[row, :FLOW]
        c = solution[row, :COST]
        k = K[i,j]
        a = A[k]
        a.x = x
        a.c = c
    end

    num = 0.0
    for (i,o) in enumerate(O)
        r = o.n 
        Lᵖ = djk(G, o)
        for (j,s) in enumerate(o.S)
            qᵣₛ = o.Q[j]
            pᵣₛ = path(G, Lᵖ, r, s)
            for a in pᵣₛ num += qᵣₛ * a.c end
        end 
    end

    den = 0.0
    for (k,a) in enumerate(A) den += a.x * a.c end

    rg = 1 - num/den
    return rg
end

export assigntraffic 

end