extends Area2D

# class member variables go here, for example:
# var a = 2
var idx
var bullet_scene = preload("res://bullet.tscn")
var bullet_instance
var active = true
var dir
var target
const SPEED = 200
#

func _ready():
	target = get_node("../ship/get_hits")
	set_process(true)

func _process(delta):
	dir = (target.get_global_pos() - get_global_pos()).normalized()
	set_global_rot(atan2(dir.x, dir.y))
	translate(delta*SPEED*Vector2(1,0))

func spawn_enemy_bullet():
	bullet_instance = bullet_scene.instance()
	var bullet_pos = get_node("shootfrom").get_global_pos()
	bullet_instance.dir = dir
	bullet_instance.set_global_rot(atan2(dir.x, dir.y))
	bullet_instance.set_global_pos(bullet_pos)
	get_node("../").add_child(bullet_instance)

func _on_timer_timeout():
	if active:
		spawn_enemy_bullet()

func _on_visibility_exit_screen():
	queue_free()