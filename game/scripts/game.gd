extends Node2D


var polarity = 1*(rand_range(0,1) > 0.5)
var asteroid_scene = preload("res://asteroid.tscn")
var enemy_scene = preload("res://enemy.tscn")
var gamma = 0.5
var accuracy = [0.4, 0.6]
var counter = 0
var data = {"time":[], "polarity_shot":[], "polarity_asteroid":[]}
var w = Globals.get("display/width")
var h = Globals.get("display/height")
const space = 10
var upper_lim
var lower_lim


func _ready():
	pass


func asteroid_wave():
	var side = rand_range(0,1) > 0.5
	upper_lim = side*space
	lower_lim = h-space+upper_lim
	for i in range(upper_lim,lower_lim,100):
		for j in range(2):
			spawn_asteroid(w-100*j+ rand_range(200,100), i , false)
	spawn_asteroid(w,rand_range(upper_lim,lower_lim), true)
	counter += 1
	if rand_range(0,1) < gamma:
		polarity = 1-polarity


func spawn_enemy(x_pos, y_pos, polarity):
	var enemy_instance = enemy_scene.instance()
	enemy_instance.set_pos(Vector2(x_pos,y_pos))
	var enemy_scale = rand_range(0.2,0.4)
	enemy_instance.set_scale(Vector2(enemy_scale,enemy_scale))
	enemy_instance.set_rot(rand_range(-20,20))
	enemy_instance.polarity = polarity
	add_child(enemy_instance)


func spawn_asteroid(x_pos, y_pos, bomb):
	var asteroid_instance = asteroid_scene.instance()
	asteroid_instance.set_pos(Vector2(x_pos,y_pos))
	var asteroid_scale = rand_range(0.2,0.4)
	if bomb:
		asteroid_scale = 0.4
	asteroid_instance.set_scale(Vector2(asteroid_scale,asteroid_scale))
	asteroid_instance.set_rot(rand_range(-20,20))
	asteroid_instance.bomb = bomb
	asteroid_instance.group = counter
	asteroid_instance.polarity = polarity
	add_child(asteroid_instance)


func _on_timer_timeout():
	spawn_enemy(w-100, rand_range(0,h), polarity)

func save_data():
		var file = File.new()
		file.open("/Users/pietro/Documents/save_try.json", file.WRITE)
		file.store_line(get_node("../").data.to_json())
		file.close()
