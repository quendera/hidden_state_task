extends ProgressBar

# class member variables go here, for example:
var style = preload("res://progress_bar.tres")
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]

func _ready():
	set_process(true)

func _process(delta):
	set_value(get_node("../../ship").charge)
	style.set_bg_color(colors[get_node("../../ship").polarity])