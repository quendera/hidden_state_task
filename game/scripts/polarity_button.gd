extends TouchScreenButton

# class member variables go here, for example:
# var a = 2
var time0 = 0
var elapsed = 0
const flip_time = 300

func _ready():
	set_process(true)

func _process(delta):
	elapsed = OS.get_ticks_msec()-time0
	get_node("../ship").shooting_pressed = is_pressed() and (elapsed > flip_time)

func _on_polarity_button_pressed():
	time0 = OS.get_ticks_msec()


func _on_polarity_button_released():
	if elapsed < flip_time :
		get_node("../ship").change_polarity()