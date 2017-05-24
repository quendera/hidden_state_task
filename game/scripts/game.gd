extends Node2D

# class member variables go here, for example:
# var a = 2
var polarity = 1*(rand_range(0,1) > 0.5)
var asteroid_scene = preload("res://asteroid.tscn")
var gamma = 0.3
var accuracy = 0.1
var counter = 0


func _ready():
	set_process(true)

func _process(delta):
	pass

func asteroid_wave():
	var side = rand_range(0,1) > 0.5
	var shift = side*150
	for i in range(30+shift,600+shift,100):
		for j in range(2):
			spawn_asteroid(i, -100*j+ rand_range(-200,-100), false)
	spawn_asteroid(rand_range(200,580), -100, true)
	counter += 1
	if rand_range(0,1) < gamma:
		polarity = 1-polarity

func spawn_asteroid(x_pos, y_pos, bomb):
	var asteroid_instance = asteroid_scene.instance()
	asteroid_instance.set_pos(Vector2(x_pos,y_pos))
	var asteroid_scale = rand_range(0.2,0.4)
	if bomb:
		asteroid_scale = 0.6
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



func _on_timer_timeout():
	asteroid_wave()
