extends Area2D

const SPEED = 600
var dir

func _process(delta):
	translate(delta*SPEED*dir)

func _ready():
	set_process(true)

func _on_enemy_bullet_area_enter(area):
	if area.has_method("destroy"):
		area.destroy()
	if area.get_name() in ["ship", "shield1", "shield2"]:
		queue_free()

func _on_visibility_exit_screen():
	queue_free()