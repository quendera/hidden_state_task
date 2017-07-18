extends TouchScreenButton

# class member variables go here, for example:
# var a = 2
signal polarity_pressed
signal polarity_released

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("polarity"):
		emit_signal("polarity_pressed")
	if event.is_action_released("polarity"):
		emit_signal("polarity_released")


