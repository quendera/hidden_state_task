extends Node2D

# class member variables go here, for example:
# var a = 2

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_button_pressed():
	get_tree().change_scene("res://game.tscn")


func _on_timer_timeout():
	get_tree().change_scene("res://game.tscn")
