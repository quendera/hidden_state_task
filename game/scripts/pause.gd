extends Node2D

var is_paused = true

func _ready():
	get_tree().set_pause(true)
	set_process_input(true)

func toggle_pause(paused):
	is_paused = not is_paused
	get_tree().set_pause(is_paused)
	get_node("../CanvasLayer/shade").set_hidden(not is_paused)
	get_node("../soundtrack").set_paused(is_paused)

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause(is_paused)
		get_node("../CanvasLayer/welcome").set_hidden(not is_paused)
	if event.is_action_pressed("exit"):
		toggle_pause(is_paused)
		get_node("confirm_quit").popup_centered()#get_node("../enemy").game_over()

func _on_confirm_quit_confirmed():
	get_node("../enemy").game_over()


func _on_confirm_quit_popup_hide():
	toggle_pause(is_paused)
