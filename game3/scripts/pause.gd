extends Node2D

var is_paused = true
var initial_screen = true


func _ready():
	get_tree().set_pause(true)
	set_process_input(true)

func toggle_pause(paused):
	is_paused = not paused
	get_tree().set_pause(is_paused)
	get_node("../CanvasLayer/shade").set_visible(is_paused)
	get_node("../soundtrack").playing = false#not is_paused


func _input(event):
	if not initial_screen:
		if event.is_action_pressed("pause"):
			toggle_pause(is_paused)
			get_node("CanvasLayer/pause").set_visible(is_paused)
	if event.is_action_pressed("exit"):
		toggle_pause(false)
		get_node("CanvasLayer/pause").set_visible(is_paused)
		get_node("CanvasLayer/instructions").set_visible(is_paused)
		get_node("CanvasLayer/confirm_quit").popup_centered()
	if event.is_action_pressed("full_screen"):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
	if initial_screen:
		if event.is_action_pressed("ui_accept") or (event is InputEventScreenTouch):
			toggle_pause(true)
			get_node("CanvasLayer/pause").set_visible(false)
			get_node("CanvasLayer/instructions").set_visible(false)
			initial_screen = false
		if event.is_action_pressed("tutorial"):
			get_tree().change_scene("res://scenes/tutorial.tscn")


func _on_confirm_quit_confirmed():
	get_node("../enemy/enemy_ship").game_over()


func _on_confirm_quit_popup_hide():
	toggle_pause(is_paused)
