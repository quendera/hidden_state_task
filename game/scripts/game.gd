extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_timer_timeout():
	var enemy_instance = preload("res://enemy.tscn").instance()
	enemy_instance.set_pos(Vector2(0,100))
	add_child(enemy_instance)
	
