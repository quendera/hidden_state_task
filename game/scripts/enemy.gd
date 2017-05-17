extends Area2D

# class member variables go here, for example:
# var a = 2
var life = 5
var active = true
var dir
var target
const SPEED = 200
#

func _ready():
	add_to_group("enemies")
	target = get_node("../ship/get_hits")
	set_process(true)

func _process(delta):
	dir = (target.get_global_pos() - get_global_pos()).normalized()
	set_global_rot(atan2(dir.x, dir.y))
	translate(delta*SPEED*Vector2(1,0))
	if life <= 0:
		queue_free()

func _on_timer_timeout():
	if active:
		var pos = get_node("shootfrom").get_global_pos()
		get_node("../").spawn_bullet(pos,dir, rand_range(0,1) > 0.5, false)

func _on_visibility_exit_screen():
	queue_free()
