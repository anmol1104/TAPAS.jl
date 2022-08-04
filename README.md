# TAPAS
Traffic Assignment by Paired Alternate Segments.

For further details refer to:
  Bar-Gera, H. (2010). Traffic assignment by paired alternative segments. Transportation Research Part B: Methodological, 44(8-9), 1022-1046.
  Xie, J., & Xie, C. (2016). New insights and improvements of using paired alternative segments for traffic assignment. Transportation Research Part B:     Methodological, 93, 406-424.

Implementation here as proposed by Xie & Xie (2016)

```julia
assigntraffic(; network, assignment=:UE, tol=1e-5, maxiters=20, maxruntime=300, log=:off)
```

Traffic Assignment by paired alternate segments

## Returns
a named tuple with keys `:metadata`, `:report`, and `:output`
- `metadata::String`  : Text defining the traffic assignment run 
- `report::DataFrame` : A log of total network flow, total network cost, and run time for every iteration
- `output::DataFrame` : Flow and cost for every arc from the final iteration

## Arguments
- `network::String`         : Network
- `assignment::Symbol=:UE`  : Assignment type; one of `:UE`, `:SO`
- `tol::Float64=1e-5`       : Tolerance level for relative gap
- `maxiters::Int64=20`      : Maximum number of iterations
- `maxruntime::Int64=300`   : Maximum algorithm run time (seconds)
- `log::Symbol`             : Log iterations (one of `:off`, `:on`)
