extends Node2D

# Data collection:
#var data = {"time":[], "polarity_shot":[], "polarity_enemy":[], "correct" : [], "steps":[],
#"escaped": [], "reaction_time" : [], "probability_blue" : []}
#var data_line = {"time":0, "polarity_shot":0, "polarity_enemy":0, "correct" : true, "steps" : 0,
#"escaped": true, "reaction_time" : 0, "probability_blue" : 0.5}

# bullets
var enemy_bullet_scene = preload("res://scenes/enemy_bullet.tscn")
var enemy_bullet_instance

# time changing attributes
var probability_blue = 0.5
var shooting = false

# life
const MAX_LIFE = 2000
const DIE_VEC = [0, 6, 12, 18, 24, 30]
const REGENERATE_VEC = [0, 6, 15, 29, 53, 107]
var life setget set_life

func set_life(new_life):
	life = new_life
	get_node("layer/boss_life/bar").set_value(100*life/float(MAX_LIFE))

var lost_life = 0
var life_sign

# attacks
#onready var attack = preload("res://scripts/attacks.gd").new()
var offset = 45
var next_attack = randi() % 2
const ATTACK_DURATIONS = [2, 1]
const ATTACK_FREQUENCY = [0.03, 0.1]


var laser_pos setget , get_laser_pos

func get_laser_pos():
	return get_node("enemy_ship/laser/position").get_global_pos()

var stealable setget , get_stealable

func get_stealable():
	return get_node("enemy_ship").stealable

var polarity setget , get_polarity

func get_polarity():
	return get_node("enemy_ship").polarity



func _ready():
	randomize()
	get_node("enemy_ship").connect("hit", self, "_on_hit")
	get_node("enemy_ship/frames").get_material().set_shader_param("x", polarity)
	set_life(MAX_LIFE)
	set_process(true)

func _process(delta):
	life = clamp(life,0,MAX_LIFE)

func _on_hit(steps, correct):
	lost_life = lose_life(steps, correct)
	set_life(life - lost_life)
	if - lost_life > 0:
		life_sign = "+"
	else:
		life_sign = ""
	get_node("enemy_ship/lost_life").set_text(life_sign+str(int(-lost_life)))


func lose_life(steps, correct):
	if correct:
		return DIE_VEC[steps]
	else:
		return -REGENERATE_VEC[steps]