using JSON
using DataFrames
using Plots
using StatPlots
using Query
gr(grid = false)

include("load_data.jl")


df
subdf = @from i in df begin
    @where (i.Streak > 50)  &&
    (i.correct == true) # && (i.reaction_time != 0)
    @select i
    @collect DataFrame
end


cor(subdf[:polarity_shot], subdf[:probability_blue])
cor(subdf[:steps], subdf[:reaction_time])

scatter(subdf,:steps, :reaction_time,
 smooth = true)

subdf[:false_alarm] = (df[:reaction_time] .!= 0) .& df[:correct]

grp = groupapply(:false_alarm, subdf, :steps
,axis_type = :discrete, compute_error = :across)
plt = plot(grp, line = :path, legend = :best, xlabel = "",
ylims=(0,0.1))


xlabel!("Steps")
ylabel!("Reaction time")
savefig(joinpath(plot_folder, "reaction.pdf"))
mean(df[200:end,:correct])
