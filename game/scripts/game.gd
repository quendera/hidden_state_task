extends Node2D

onready var enemy = get_node("enemy") 
onready var player = get_node("player")

func _ready():
	set_process(true)
	get_node("enemy").connect("exploded", self, "_on_exploded")
	set_process_input(true)

func _process(delta):
	get_node("energy").set_global_pos(get_node("enemy/centroid").get_global_pos())
	get_node("energy/absorb").set_global_pos(get_node("player/ship/get_hits").get_global_pos())


func _on_exploded():
	get_node("energy").start()