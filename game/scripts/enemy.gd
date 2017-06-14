extends Area2D

# class member variables go here, for example:
var polarity = 0
var colors = [Color(1,0.2,0.2), Color(0.2,0.2,1)]

func _ready():
	add_to_group("enemies")
	get_node("frames").set_modulate(colors[polarity])

func explode():
	pass


func reflect():
	pass

func _on_visibility_exit_screen():
	queue_free()
