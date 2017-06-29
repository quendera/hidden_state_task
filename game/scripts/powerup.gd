extends Node2D

# class member variables go here, for example:
var polarity = 1
var activation = 0

func _ready():
	set_process(true)
	get_node("bars").set_frame(activation)

func _process(delta):
	polarity = get_node("../../ship").polarity
	activation = get_node("../../ship").steps
	get_node("bars").set_frame(activation)
	get_node("bars").get_material().set_shader_param("x", polarity == 1)
