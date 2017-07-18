extends Node2D

# class member variables go here, for example:
var activation = 0

func _ready():
	set_process(true)
	get_node("bars").set_frame(activation)

func _process(delta):
	activation = get_node("../../ship").steps
	get_node("bars").set_frame(activation)

