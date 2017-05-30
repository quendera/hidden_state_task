extends Area2D

# class member variables go here, for example:
var polarity

func _ready():
	add_to_group("enemies")

func explode():
	pass


func reflect():
	pass

func _on_visibility_exit_screen():
	queue_free()
