extends Area2D


# class member variables go here, for example:
var polarity
const colors = ["red", "blue"]


func _ready():
	set_process(true)


func _process(delta):
	polarity = get_node("../").polarity
	get_node("frames").set_frame(polarity)

