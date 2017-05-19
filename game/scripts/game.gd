extends Node2D

# class member variables go here, for example:
# var a = 2
var polarity = rand_range(0,1) > 0.5
var bullet_scene = preload("res://bullet.tscn")
var rate = 1 # rate of change in Hz

func _ready():
	set_process(true)

func _process(delta):
	if rand_range(0,1) < delta:
		polarity = 1-polarity


func _on_timer_timeout():
	var enemy_instance = preload("res://enemy.tscn").instance()
	enemy_instance.set_pos(Vector2(0,100))
	enemy_instance.set_z(1)
	add_child(enemy_instance)
	
func spawn_bullet(pos, dir, polarity, friendly, masked):
	var bullet_instance = bullet_scene.instance()
	bullet_instance.dir = dir
	bullet_instance.polarity = polarity
	bullet_instance.friendly = friendly
	bullet_instance.masked = masked
	bullet_instance.set_global_rot(PI+atan2(dir.x, dir.y))
	bullet_instance.set_global_pos(pos)
	add_child(bullet_instance)
