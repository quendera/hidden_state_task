extends Area2D

const SPEED = 600
var dir
var friendly
var polarity

func _process(delta):
	translate(delta*SPEED*dir)

func _ready():
	get_node("blue").set_hidden(polarity == 0)
	get_node("red").set_hidden(polarity == 1)
	set_process(true)

func _on_bullet_area_enter(area):
	if not friendly:
		if area.has_method("destroy"):
			area.destroy()
		if area.get_name() == "shield" and polarity == area.polarity:
			queue_free()

func _on_visibility_exit_screen():
	queue_free()