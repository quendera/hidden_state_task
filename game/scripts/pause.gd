extends Node2D

var is_paused = true

func _ready():
	get_tree().set_pause(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("pause"):
		is_paused = not is_paused
		get_tree().set_pause(is_paused)
		get_node("../CanvasLayer/shade").set_hidden(not is_paused)
		get_node("../soundtrack").set_paused(is_paused)