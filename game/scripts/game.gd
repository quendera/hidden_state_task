extends Node2D

# class member variables go here, for example:
# var a = 2
var polarity = rand_range(0,1) > 0.5
var bullet_scene = preload("res://bullet.tscn")
var asteroid_scene = preload("res://asteroid.tscn")
var rate = 1 # rate of change in Hz
var counter = 0

func _ready():
	set_process(true)
	for i in range(0,720,50):
		for j in range(2):
			spawn_asteroid(i, 100*j+ rand_range(0,100))

func _process(delta):
	if rand_range(0,1) < delta:
		polarity = 1-polarity


func spawn_asteroid(x_pos, y_pos):
	var asteroid_instance = asteroid_scene.instance()
	asteroid_instance.set_pos(Vector2(x_pos,y_pos))
	var asteroid_scale = rand_range(0.2,0.4)
	asteroid_instance.set_scale(Vector2(asteroid_scale,asteroid_scale))
	var asteroid_rot = rand_range(-20,20)
	asteroid_instance.set_rot(asteroid_rot)
	asteroid_instance.group = counter
	asteroid_instance.add_to_group("asteroid"+str(counter))
	add_child(asteroid_instance)
	
func spawn_bullet(pos, dir, polarity, friendly, masked):
	var bullet_instance = bullet_scene.instance()
	bullet_instance.dir = dir
	bullet_instance.polarity = polarity
	bullet_instance.friendly = friendly
	bullet_instance.masked = masked
	bullet_instance.set_global_rot(PI+atan2(dir.x, dir.y))
	bullet_instance.set_global_pos(pos)
	add_child(bullet_instance)
