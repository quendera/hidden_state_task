extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var bullet_scene = preload("res://bullet.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_timer_timeout():
	var enemy_instance = preload("res://enemy.tscn").instance()
	enemy_instance.set_pos(Vector2(0,100))
	enemy_instance.set_z(1)
	add_child(enemy_instance)
	
func spawn_bullet(pos, dir, polarity = 0, friendly = true):
	var bullet_instance = bullet_scene.instance()
	bullet_instance.dir = dir
	bullet_instance.polarity = polarity
	bullet_instance.friendly = friendly
	bullet_instance.set_global_rot(atan2(dir.x, dir.y))
	bullet_instance.set_global_pos(pos)
	add_child(bullet_instance)
