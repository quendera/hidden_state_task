extends Node2D

var passed = {"polarity" : false, "arrows" : false, "shield" : false}
var initial_polarity
var can_shoot = false
var ready2start = false
var countdown = false

func _ready():
	initial_polarity = global.player.polarity
	global.enemy.SPEED = 0
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_accept") and ready2start:
		get_tree().change_scene("res://scenes/level1.tscn")

func _process(delta):
	if not (passed.polarity and passed.arrows):
		global.player.ready2shoot = false
	elif not can_shoot:
		global.player.ready2shoot = true
		can_shoot = true
		get_node("game/CanvasLayer2/story").put_text(1)
	if global.player.polarity != initial_polarity:
		passed.polarity = true
	if global.player.position.y -50 < global.enemy.get_node("centroid").position.y:
		passed.arrows = true
	if global.player.fast_reaction and not countdown:
		passed.shield = true
		global.player.hits = 0
		get_node("game/CanvasLayer2/story").put_text(1)
		$next_step.start()
		countdown = true

func _on_next_step_timeout():
	for node in get_node("game/player/layer").get_children():
		node.set_hidden(false)
	get_node("game/CanvasLayer2/story").put_text(1)
	ready2start = true