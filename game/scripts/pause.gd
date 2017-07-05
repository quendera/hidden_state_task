extends Node2D

var is_paused = true
var initial_screen = true

func _ready():
	get_tree().set_pause(true)
	set_process_input(true)

func toggle_pause(paused):
	is_paused = not paused
	get_tree().set_pause(is_paused)
	get_node("../CanvasLayer/shade").set_hidden(not is_paused)
	get_node("../soundtrack").set_paused(is_paused)

func _input(event):
	if not initial_screen:
		if event.is_action_pressed("pause"):
			toggle_pause(is_paused)
			get_node("CanvasLayer/pause").set_hidden(not is_paused)
	if event.is_action_pressed("exit"):
		toggle_pause(false)
		get_node("CanvasLayer/pause").set_hidden(true)
		get_node("CanvasLayer/instructions").set_hidden(true)
		get_node("CanvasLayer/confirm_quit").popup_centered()
	if event.is_action_pressed("full_screen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
	if initial_screen:
		if event.is_action_pressed("ui_accept"):
			toggle_pause(true)
			get_node("CanvasLayer/pause").set_hidden(true)
			get_node("CanvasLayer/instructions").set_hidden(true)
			initial_screen = false


func _on_confirm_quit_confirmed():
	get_node("../enemy").game_over()


func _on_confirm_quit_popup_hide():
	toggle_pause(is_paused)
