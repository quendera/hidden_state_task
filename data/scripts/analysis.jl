using JSON
using DataFrames
using Plots
using StatPlots
using Query
gr(grid = false)

include("load_data.jl")


by(size, df, :Name)
subdf = @from i in df begin
    @where (i.Streak > 50) &&
    (i.correct == false)  && (i.reaction_time != 0)
    @select i
    @collect DataFrame
end

subdf[:false_alarm] = (subdf[:reaction_time] .!= 0) .& subdf[:correct]

function _median(df, xaxis, x,  y)
  ymean = by(df, x) do dd
      DataFrame(m = median(dd[y]))
  end
  return StatPlots.extend_axis(ymean, x, :m, xaxis, NaN)
end

grp = groupapply(_median, subdf, :probability_blue,:reaction_time,
axis_type = :discrete,compute_error = (:across, :Name))
plt = plot(grp, line = :scatter, legend = :best, xlabel = "",
 #xtick = 0.05:0.1:0.95,
# yticks = 0:0.1:0.3,
 color = :blue,
tickfont = Plots.Font("sans-serif",12,:hcenter,:vcenter,0.0,RGB{U8}(0.0,0.0,0.0)),
linecolor = :blue,
linewidth = 3,
marker = (:circle, 10, 1.0, :blue, stroke(3, 1.0, :blue, :dot)),
left_margin = 10mm, bottom_margin = 10mm)


# xlabel!("Steps")
# ylabel!("Reaction time")
#savefig(joinpath(plot_folder, "reaction_cumulative.pdf"))
mean(df[200:end,:correct])
