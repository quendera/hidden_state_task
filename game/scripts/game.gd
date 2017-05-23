extends Node2D

# class member variables go here, for example:
# var a = 2
var polarity = int(rand_range(0,1) > 0.5)
var bullet_scene = preload("res://bullet.tscn")
var asteroid_scene = preload("res://asteroid.tscn")
var gamma = 0.7
var counter = 0

func _ready():
	set_process(true)

func _process(delta):
	pass

func asteroid_wave():
	var side = rand_range(0,1) > 0.5
	var bomb = true
	for i in range(side*150,600+side*150,50):
		for j in range(2):
			spawn_asteroid(i, -100*j+ rand_range(-200,-100), false)
	spawn_asteroid(300, -100, true)
	counter += 1
	if rand_range(0,1) < gamma:
		polarity = 1-polarity

func spawn_asteroid(x_pos, y_pos, bomb):
	var asteroid_instance = asteroid_scene.instance()
	asteroid_instance.set_pos(Vector2(x_pos,y_pos))
	var asteroid_scale = rand_range(0.2,0.4)
	asteroid_instance.set_scale(Vector2(asteroid_scale,asteroid_scale))
	var asteroid_rot = rand_range(-20,20)
	asteroid_instance.set_rot(asteroid_rot)
	asteroid_instance.bomb = bomb
	if bomb:
		asteroid_instance.set_z(1)
	asteroid_instance.group = counter
	asteroid_instance.polarity = polarity
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


func _on_timer_timeout():
	asteroid_wave()
