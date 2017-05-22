extends Area2D

# class member variables go here, for example:
var polarity = 0
var polarity_change = false
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("polarity_change"):
		if not polarity_change:
			polarity = 1-polarity
			polarity_change = true
	else:
		polarity_change = false
	get_node("frames").set_frame(2-polarity)
