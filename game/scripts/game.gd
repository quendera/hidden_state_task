extends Node2D


var polarity = 1*(rand_range(0,1) > 0.5)
var asteroid_scene = preload("res://asteroid.tscn")
var gamma = 0.3
var accuracy = 0.1
var counter = 0


func _ready():
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
	asteroid_instance.set_rot(rand_range(-20,20))
	asteroid_instance.bomb = bomb
	asteroid_instance.group = counter
	asteroid_instance.polarity = polarity
	add_child(asteroid_instance)


func _on_timer_timeout():
	asteroid_wave()
