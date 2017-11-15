extends Area2D


# Data collection:
var data = {"time":[], "polarity_shot":[], "polarity_enemy":[], "correct" : [], "steps":[],
"fast_reaction": [], "reaction_time" : [], "reaction_chosen" : [], "probability_blue" : [],
"probability_neutral" : [], "bias_blue" : [], "attack_number" : [], "bullet_0" :[], "bullet_1" : [], "bullet_2" : [],
"choice_time" : []}
var data_line = {"time":0, "polarity_shot":0, "polarity_enemy":0, "correct" : 1, "steps" : 0,
"fast_reaction": 1, "reaction_time" : 0, "reaction_chosen" : "none", "probability_blue" : 0.5,
"probability_neutral" : 0.0, "bias_blue" : global.bias_blue, "attack_number" : 0, "bullet_0" : 0, "bullet_1" : 0, "bullet_2" : 0,
"choice_time" : 0}

var data_keys = data.keys()
var query_string = "INSERT INTO testdata ("
var query_line = ""
var has_data = false

func set_query_string_header():
	for i in range(data_keys.size()):
		query_string += data_keys[i]
		if i < data_keys.size() - 1:
			query_string += ", "
	query_string += ") values "

func set_query_line():
	query_line = "("
	for i in range(data_keys.size()):
		if typeof(data_line[data_keys[i]]) == TYPE_STRING:
			query_line += "'"+data_line[data_keys[i]]+"'"
		else:
			query_line += str(data_line[data_keys[i]])
		if i < data_keys.size() - 1:
			query_line += ", "
	query_line += "), "

func add_query_line():
	has_data = true
	set_query_line()
	query_string += query_line


#constants
var SPEED = 30

# bullets
var enemy_bullet_scene = preload("res://scenes/enemy_bullet.tscn")
var enemy_bullet_instance

# time changing attributes
var polarity = int(rand_range(0,1) > 0.5)
#const PROBABILITIES = [0.1, 0.3, 0.4, 0.45, 0.55, 0.6, 0.7, 0.9]
const ALPHA = 2
const BETA = 2
var probability_blue = 0.5
var shooting = false setget set_shooting

func set_shooting(new_shooting):
	if shooting and not new_shooting:
		attack_end_time = OS.get_ticks_msec()
	shooting = new_shooting

# navigate
var dir
var pos
const low_x = 900
const high_x = 1100
const low_y = 250
const high_y = 500



# life
const max_life = 2000
var life = max_life
const die_vec = [0, 6, 12, 18, 24, 30]
const regenerate_vec = [0, 6, 15, 29, 53, 107]
var lost_life = 0
var life_sign

# attacks
#onready var attack = preload("res://scripts/attacks.gd").new()
var offset = 45
const attack_amount = 3
var next_attack = randi() % 2
const attack_frequency = [0.075, 0.1, 0.3]
var num_rays = 3
var attack_start_time = 0
var attack_end_time = 0

# signals

signal exploded


#### Public Functions

var laser_pos setget , get_laser_pos

func get_laser_pos():
	return get_node("laser/position").get_global_position()



func _ready():
	global.enemy_path = get_path()
	set_query_string_header()
	randomize()
	dir = Vector2(cos(rand_range(0,2*PI)),sin(rand_range(0,2*PI)))
	add_to_group("enemies")
	get_node("frames").get_material().set_shader_param("x", polarity)
	$sound_enemy_engine.play()
	set_process(true)

func _process(delta):
	var angle2ship = $laser.get_angle_to(global.player.get_node("ship/get_hits").global_position)
	$laser.rotate(angle2ship+PI)
	life = clamp(life,0,max_life)
	pos = $centroid.global_position
	translate(SPEED*delta*dir)

	if (dir.x)*(pos.x-clamp(pos.x, low_x, high_x)) > 0.001:
		dir.x = -dir.x
	if (dir.y)*(pos.y-clamp(pos.y, low_y, high_y)) > 0.001:
		dir.y = -dir.y
	if not $sound_enemy_engine.playing:
		$sound_enemy_engine.play()

func save_data():
	var file = File.new()
	file.open("user://data" + str(OS.get_unix_time())+".json", file.WRITE)
	file.store_line(to_json(data))
	file.close()

func _on_bullet_hit(steps):
	data_line["time"] = OS.get_ticks_msec()
	data_line["polarity_shot"] = global.player.polarity
	data_line["probability_blue"] = probability_blue
	data_line["polarity_enemy"] = polarity
	data_line["correct"] = int(data_line["polarity_shot"] == data_line["polarity_enemy"])
	data_line["steps"] = steps
	data_line["attack_number"] = next_attack
	data_line["choice_time"] = attack_end_time - attack_start_time
	global.player.movement_time = 0
	global.player.start_time =  OS.get_ticks_msec()
	$reaction_window.start()
	global.player.reaction_window = true
	global.player.reaction_chosen = "none"
	global.player.get_node("ship").combo = false
	global.player.fast_reaction = false
	life -= lost_life
	if - lost_life > 0:
		life_sign = "+"
	else:
		life_sign = ""
	get_node("lost_life").set_text(life_sign+str(int(-lost_life)))
	get_node("frames").get_material().set_shader_param("hidden", false)



func lose_life(steps, correct):
	if correct:
		return die_vec[steps]
	else:
		return -regenerate_vec[steps]


func reflect(steps):
	get_node("laser").activate(polarity)
	lost_life = lose_life(steps, false)
	_on_bullet_hit(steps)


func explode(steps):
	get_node("explosion").set_scale(Vector2(steps/float(5), steps/float(5)))
	get_node("explosion").get_material().set_shader_param("x", polarity)
	get_node("explosion").show()
	get_node("anim").play("explosion")
	get_node("sound_explosion").play()
	global.player.get_node("ship/anim").play("laser")
	lost_life = lose_life(steps, true)
	_on_bullet_hit(steps)


func game_over():
#	if has_data:
#		get_node("/root/game").send_string(query_string.substr(0, query_string.length( )-2)+";")
	print("not sending data!")
	save_data()
	get_tree().quit()

func _on_anim_finished(name):
	data_line["reaction_time"] = global.player.movement_time
	if global.player.reaction_chosen == "none":
		global.player.reaction_chosen = "timeout"
	data_line["reaction_chosen"] = global.player.reaction_chosen
	data_line["fast_reaction"] = int(global.player.fast_reaction)
	for key in data_line.keys():
		data[key].push_back(data_line[key])
	add_query_line()
	$frames.get_material().set_shader_param("hidden", true)
	global.player.ready2shoot = true
	global.player.get_node("ship").active = false
	global.player.charge = 0
	$lost_life.set_text("")
	if life <= 0:
		game_over()
	probability_blue = sample() #PROBABILITIES[randi()%8]
	polarity = int(probability_blue > 0.5)
	$frames.get_material().set_shader_param("x", polarity)
	begin_attack()

func beta(q):
	return float(pow(q, ALPHA -1)*pow(1-q, BETA -1))

func sample():
	var attempt = rand_range(0,1)
	while rand_range(0, 1) > beta(attempt)/beta(0.5):
		attempt = rand_range(0,1)
	return attempt



### ATTACK ###

func spawn_enemy_bullet(dir):
	enemy_bullet_instance = enemy_bullet_scene.instance()
	enemy_bullet_instance.init(dir, int(rand_range(0,1) < probability_blue))
	enemy_bullet_instance.global_position = $shoot_from.global_position
	get_parent().add_child(enemy_bullet_instance)

func _on_shooting_timeout():
	if shooting:
		attack(next_attack)

func begin_attack():
	next_attack = (randi() % 3)
	while next_attack == 1:
		next_attack = (randi() % 3)
#	next_attack = 2
	shooting = true
	attack_start_time = OS.get_ticks_msec()
	$shooting.set_wait_time(attack_frequency[next_attack])


func attack(attack_number):
	if attack_number == 0:
		attack0()
	elif attack_number == 1:
		attack1()
	elif attack_number == 2:
		attack2()

func get_num_rays():
	return get_num_rays_norm(((OS.get_ticks_msec() - attack_start_time) % 2000)/2000.0)

func get_num_rays_norm(t):
	if t > 0.85:
		return 3
	elif t > 0.5:
		return 0
	elif t > 0.35:
		return 2
	else:
		return 0

func attack0():
	num_rays = get_num_rays()
	for i in range(num_rays):
		var angle = PI+0.2*PI*(i-0.5*(num_rays-1))+rand_range(-0.2,0.2)
		var shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)


func attack1():
	offset = -offset
	for i in range(1, 1+ get_num_rays()):
		spawn_enemy_bullet(Vector2(-1,0))
		enemy_bullet_instance.translate(Vector2(0,180*(i-2)+offset))
		var vec = (global.player.get_node("ship/get_hits").get_global_position() -
		enemy_bullet_instance.get_global_position())
#		vec.x *= 0.9
		enemy_bullet_instance.dir = vec.normalized()

func attack2():
	for i in range(1, 4):
		var shooting_offset = sin(OS.get_ticks_msec()/float(1000))*0.5
		var angle = shooting_offset+PI+PI*(i-2)/float(5)
		var shooting_dir = Vector2(cos(angle),sin(angle))
		spawn_enemy_bullet(shooting_dir)


func _on_reaction_window_timeout():
	global.player.reaction_window = false

