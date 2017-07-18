extends Area2D


# Data collection:
var data = {"time":[], "polarity_shot":[], "polarity_enemy":[], "correct" : [], "steps":[],
"escaped": [], "reaction_time" : [], "probability_blue" : []}
var data_line = {"time":0, "polarity_shot":0, "polarity_enemy":0, "correct" : true, "steps" : 0,
"escaped": true, "reaction_time" : 0, "probability_blue" : 0.5}

#constants
const SPEED = 30

# bullets
var enemy_bullet_scene = preload("res://scenes/enemy_bullet.tscn")
var enemy_bullet_instance

# time changing attributes
var polarity = 1*(rand_range(0,1) > 0.5)
var probability_blue = 0.5
var stealable = false
var shooting = false

# navigate
var dir
var pos
const LOW_X = 900
const HIGH_X = 1100
const LOW_Y = 250
const HIGH_Y = 500



# attacks
#onready var attack = preload("res://scripts/attacks.gd").new()
var offset = 45
var next_attack = randi() % 2
const ATTACK_DURATIONS = [2, 1]
const ATTACK_FREQUENCY = [0.03, 0.1]


# signals

signal hit


#### Public Functions

var laser_pos setget , get_laser_pos

func get_laser_pos():
	return get_node("laser/position").get_global_pos()



func _ready():
	randomize()
	dir = Vector2(cos(rand_range(0,2*PI)),sin(rand_range(0,2*PI)))
	add_to_group("enemies")
	set_process(true)

func _process(delta):
	var angle2ship = get_node("laser").get_angle_to(global.player.get_node("ship/get_hits").get_global_pos())
	get_node("laser").rotate(angle2ship+PI/2)
	pos = get_node("centroid").get_global_pos()
	translate(SPEED*delta*dir)

	if (dir.x)*(pos.x-clamp(pos.x, LOW_X, HIGH_X)) > 0.001:
		dir.x = -dir.x
	if (dir.y)*(pos.y-clamp(pos.y, LOW_Y, HIGH_Y)) > 0.001:
		dir.y = -dir.y

func save_data():
	var file = File.new()
	file.open("user://data" + str(OS.get_unix_time())+".json", file.WRITE)
	file.store_line(data.to_json())
	file.close()

func _on_bullet_hit(steps,correct):
	data_line["time"] = OS.get_ticks_msec()
	data_line["polarity_shot"] = global.player.polarity
	data_line["probability_blue"] = probability_blue
	data_line["polarity_enemy"] = polarity
	data_line["correct"] = (data_line["polarity_shot"] == data_line["polarity_enemy"])
	data_line["steps"] = steps
	data_line["escaped"] = false
	global.player.get_node("ship").movement_time = 0
	global.player.get_node("ship").start_time =  OS.get_ticks_msec()
	global.player.ready2shield = true
	get_node("deactivate_shield").start()
	get_node("frames").get_material().set_shader_param("hidden", false)
	emit_signal("hit", steps, correct)




func explode(steps, correct):
	if correct:
		stealable = true
		get_node("energy").start()
		get_node("explosion").set_scale(Vector2(steps/float(5), steps/float(5)))
		get_node("explosion").get_material().set_shader_param("x", polarity)
		get_node("explosion").show()
		get_node("anim").play("explosion")
		get_node("sound").play("explosion")
	else:
		get_node("laser").activate(polarity)
	_on_bullet_hit(steps, correct)


func game_over():
	save_data()
	get_tree().quit()

func _on_anim_finished():
	data_line["escaped"] = not get_node("laser").hit
	data_line["reaction_time"] = global.player.get_node("ship").movement_time
	for key in data_line.keys():
		data[key].push_back(data_line[key])
	get_node("frames").get_material().set_shader_param("hidden", true)
	global.player.ready2shoot = true
	global.player.charge = 0
	get_node("lost_life").set_text("")
#	if life <= 0:
#		game_over()
	probability_blue = 0.05+0.1*(randi()%10)
	polarity = int(rand_range(0,1) < probability_blue)
	get_node("frames").get_material().set_shader_param("x", polarity)
	begin_attack()

### ATTACK ###

func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir, int(rand_range(0,1) < probability_blue))
	enemy_bullet_instance.set_global_pos(get_node("shoot_from").get_global_pos())
	get_node("../").add_child(enemy_bullet_instance)

func _on_shooting_timeout():
	if shooting:
		attack(next_attack)

func begin_attack():
	next_attack = (randi() % 2)
	shooting = true
	get_node("shooting").set_wait_time(ATTACK_FREQUENCY[next_attack])
	get_node("end_attack").set_wait_time(ATTACK_DURATIONS[next_attack])
	get_node("end_attack").start()

func _on_end_attack_timeout():
	shooting = false


func attack(attack_number):
	if attack_number == 0:
		attack0()
	elif attack_number == 1:
		attack1()

func get_num_rays(t):
	if t > 0.78:
		return 3
	elif t > 0.61:
		return 0
	elif t > 0.39:
		return 2
	elif t > 0.22:
		return 0
	else:
		return 1

func attack0():
	var num_rays = get_num_rays(get_node("end_attack").get_time_left()/
	get_node("end_attack").get_wait_time())
	for i in range(num_rays):
		var angle = PI+0.2*PI*(i-0.5*(num_rays-1))+rand_range(-0.2,0.2)
		var shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)


func attack1():
	offset = -offset
	for i in range(5):
		spawn_enemy_bullet(Vector2(-1,0))
		enemy_bullet_instance.translate(Vector2(0,180*(i-2)+offset))
		var vec = (global.player.get_node("ship/get_hits").get_global_pos() -
		enemy_bullet_instance.get_global_pos())
		vec.x *= 0.8
		enemy_bullet_instance.dir = vec.normalized()



func _on_deactivate_shield_timeout():
	stealable = false
	global.player.ready2shield = false
	get_node("end_attack").stop()
	shooting = false
