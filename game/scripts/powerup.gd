extends Node2D

# class member variables go here, for example:
var polarity = 1
var activation = 0

func _ready():
	set_process(true)

func _process(delta):
	polarity = get_node("../../ship").polarity
	activation = get_node("../../ship").steps
	for i in range(5):
		get_node("circle"+str(i+1)).get_material().set_shader_param("x", polarity == 1)
		get_node("circle"+str(i+1)).get_material().set_shader_param("active", i < activation)
		get_node("circle"+str(i+1)).show()
