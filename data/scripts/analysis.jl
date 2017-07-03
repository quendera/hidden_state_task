using JSON
using DataFrames
using Plots
using StatPlots
gr(grid = false)

include("load_data.jl")

df

cor(df[:polarity_shot], df[:probability_blue])

subdf = df[df[:correct], :]
cor(subdf[:steps], subdf[:reaction_time])
scatter(subdf,:steps, :reaction_time, smooth = true)
violin(subdf, :steps, :reaction_time)
mean(subdf[:escaped])

grp = groupapply(:density, subdf[100:end,:], :steps, group =[:probability_correct]
,axis_type = :discrete)
plt = plot(grp, line = :bar, legend = :best)


grp = groupapply(:estimate, df, :probability_correct
,axis_type = :discrete, compute_error = :across)
plt = plot(grp, line = :bar, legend = :best, ylims = (0,1))

mean(df[200:end,:correct])
