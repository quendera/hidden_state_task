extends Node2D


func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().set_pause(not get_tree().is_paused())