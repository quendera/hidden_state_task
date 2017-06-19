extends Area2D

const SPEED = 500
var dir

func _process(delta):
	translate(delta*SPEED*dir)

func _ready():
	set_rot(PI+atan2(dir.x,dir.y))
	set_process(true)

func _on_enemy_bullet_area_enter(area):
	if area.get_name() == "ship":
		area.explode()
		queue_free()

func _on_visibility_exit_screen():
	queue_free()

func init(_dir):
	dir = _dir

func _on_enemy_bullet_exit_tree():
	pass
