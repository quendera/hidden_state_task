extends Area2D

const SPEED = 1000
var dir
var polarity

func _process(delta):
	translate(delta*SPEED*dir)

func _ready():
	get_node("frames").set_frame(int(polarity))
	set_rot(PI+atan2(dir.x,dir.y))
	set_process(true)

func _on_enemy_bullet_area_enter(area):
	if area.get_name() == "ship":
		area.explode()

func _on_visibility_exit_screen():
	queue_free()

func init(_dir, _polarity):
	dir = _dir
	polarity = _polarity

func _on_enemy_bullet_exit_tree():
	pass
