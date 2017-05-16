extends Area2D

# class member variables go here, for example:
var polarity = 0
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("polarity_blue") and polarity == 0:
		polarity = 1
	if Input.is_action_pressed("polarity_red") and polarity == 1:
		polarity = 0
	get_node("blue").set_hidden(polarity == 0)
	get_node("red").set_hidden(polarity == 1)
