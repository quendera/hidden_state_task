strictify(v::AbstractVector) = convert(Vector{typeof(v[1])},v)

data_folder = joinpath(dirname(dirname(@__FILE__)), "raw_data")
subject_folders = filter(isdir,joinpath.(data_folder,readdir(data_folder)))
plot_folder = joinpath(dirname(data_folder),"plots")

df = DataFrame()

for subject_folder in subject_folders
    for file in readdir(subject_folder)
        if file[end-4:end] != ".json"
            continue
        end
        data = JSON.parsefile(joinpath(subject_folder,file))
        dataf = DataFrame()
        flag = false
        for key in keys(data)
            if length(data[key]) > 0
                dataf[Symbol(key)] = strictify(data[key])
            else
                flag = true
            end
        end
        dataf[:File] = file
        dataf[:Name] = subject_folder
        dataf[:Streak] = 1:size(dataf,1)
        if !flag
            if df == DataFrame()
                df = dataf
            else
                append!(df,dataf)
            end
        end
    end
end

get_prob_correct(pol, prob) = 0.2*round(((pol == 1)? prob : 1-prob)/0.2)

df[:probability_correct] = get_prob_correct.(df[:polarity_shot], df[:probability_blue])
df[:estimate] = 0.5+((-0.05+0.1*df[:steps]).*(-1).^(1+df[:correct]))
df[:centered_steps] = df[:steps]-3
