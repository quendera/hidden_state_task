extends TouchScreenButton

# class member variables go here, for example:
# var a = 2
var time0 = 0
var elapsed = 0
var button_pressed = false
const flip_time = 300

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("polarity"):
		_on_polarity_button_pressed()
		button_pressed = true
	if event.is_action_released("polarity"):
		_on_polarity_button_released()
		button_pressed = false


func _process(delta):
	elapsed = OS.get_ticks_msec()-time0
	get_node("../../ship").shooting_pressed = button_pressed and (elapsed > flip_time)
	get_material().set_shader_param("x", get_node("../../ship").polarity)


func _on_polarity_button_pressed():
	time0 = OS.get_ticks_msec()
	button_pressed = true


func _on_polarity_button_released():
	if elapsed < flip_time :
		get_node("../../ship").change_polarity()
	button_pressed = false