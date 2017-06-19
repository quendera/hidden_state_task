extends ProgressBar

# class member variables go here, for example:
var style = preload("res://progress_bar.tres")
var style_bg = preload("res://progress_bar_bg.tres")
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]
var polarity = -1

func _ready():
	set_process(true)

func _process(delta):
	if polarity != get_node("../../ship").polarity:
		var new_color = colors[get_node("../../ship").polarity]
		var new_color_bg = new_color.linear_interpolate(Color(1,1,1),0.5)
		style.set_bg_color(new_color)
		style_bg.set_bg_color(new_color_bg)
		polarity = get_node("../../ship").polarity
		set_value(1) # hack to make sure it gets redrawn
	set_value(get_node("../../ship").charge)