extends Node2D

# class member variables go here, for example:
# var a = 2
var passed = {"polarity" : false, "arrows" : false, "shield" : false}
var initial_polarity
var can_shoot = false
var ready2start = false

func _ready():
	initial_polarity = get_node("../ship").polarity
	get_tree().set_pause(false)
	get_node("../enemy").SPEED = 0
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") and ready2start:
		get_tree().change_scene("res://scenes/level1.tscn")

func _process(delta):
	if not (passed.polarity and passed.arrows):
		get_node("../ship").ready2shoot = false
		get_node("../ship").ready2shield = false
	elif not can_shoot:
		get_node("../ship").ready2shoot = true
		can_shoot = true
		get_node("CanvasLayer/story").put_text(1)
	if get_node("../ship").polarity != initial_polarity:
		passed.polarity = true
	if get_node("../ship").get_global_pos().y -50 < get_node("../enemy/centroid").get_global_pos().y:
		passed.arrows = true
	if get_node("../ship").escaped:
		passed.shield = true
		get_node("../ship").hits = 0
		get_node("CanvasLayer/story").put_text(2)
		get_node("full_mode").start()

func _on_full_mode_timeout():
	for node in get_node("../CanvasLayer").get_children():
		node.set_hidden(false)
	get_node("CanvasLayer/story").put_text(3)
	ready2start = true