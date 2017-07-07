extends Area2D

const SPEED = 450
var dir
var polarity

func _process(delta):
	translate(delta*SPEED*dir)
	if not get_node("frames").get_frame() == int(polarity):
		get_node("frames").set_frame(int(polarity))


func _ready():
	set_process(true)

func _on_enemy_bullet_area_enter(area):
	if area.get_name() == "ship" and not area.active:
		area.explode()
		queue_free()

func _on_visibility_exit_screen():
	queue_free()

func init(_dir, _polarity):
	dir = _dir
	polarity = _polarity
	get_node("frames").set_frame(int(polarity))