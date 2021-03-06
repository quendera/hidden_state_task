extends Node2D


const FLIP_TIME = 300


var time0 = 0
var button_pressed = false
var ready2shoot = true
var ready2shield = false
var shooting_pressed = false
var shooting = false
var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_instance

var hits setget set_hits
func set_hits(new_hits):
	hits = new_hits
	get_node("layer/hits").set_text("HITS "+str(hits))

var charge = 0 setget set_charge
func set_charge(new_charge):
	charge = new_charge
	var steps = int(floor(new_charge/25))+(new_charge > 0 )
	if shooting:
		bullet_instance.steps = steps
	get_node("layer/powerup/bars").set_frame(steps)

var charging_velocity = 100

var polarity setget set_polarity
func set_polarity(new_polarity):
	polarity = new_polarity
	get_node("layer/powerup/bars").get_material().set_shader_param("x", new_polarity == 1)
	get_node("layer/polarity_button").get_material().set_shader_param("x", new_polarity == 1)
	get_node("ship/frames").get_material().set_shader_param("x", new_polarity == 1)

func _on_polarity_button_pressed():
	time0 = OS.get_ticks_msec()
	button_pressed = true


func _on_polarity_button_released():
	if OS.get_ticks_msec() < time0+FLIP_TIME :
		set_polarity(1 - polarity)
	button_pressed = false

func _on_ship_exploded(enemy_polarity):
	if not (polarity == enemy_polarity):
		explode_ship()

func _on_shield_pressed():
	get_node("ship").shield(ready2shield)

func _on_shield_off_timeout():
	get_node("ship").active = false

func _ready():
	get_node("ship/shield").connect("pressed", self, "_on_shield_pressed")
	get_node("ship/shield_off").connect("timeout", self, "_on_shield_off_timeout")
	get_node("ship").connect("exploded", self, "_on_ship_exploded")
	set_polarity( int(rand_range(0,1) > 0.5) )
	set_hits(0)
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.is_action_pressed("polarity"):
		_on_polarity_button_pressed()
	if event.is_action_released("polarity"):
		_on_polarity_button_released()
	if event.is_action_pressed("shield"):
		get_node("ship").shield(ready2shield)
	if event.is_action_pressed("steal"):
		steal()

func _process(delta):
#shoot
	if ready2shoot:
		ready2shield = false
	shooting_pressed = button_pressed and (OS.get_ticks_msec() > time0+FLIP_TIME)
	if shooting_pressed and ready2shoot and not get_node("ship").active:
		if not shooting:
			spawn_bullet(polarity)
			shooting = true
		set_charge(clamp(charge+delta*charging_velocity, 0, 100))
	if not shooting_pressed and shooting:
		bullet_instance.detached = true
		shooting = false
		ready2shoot = false

func spawn_bullet(polarity):
	bullet_instance = bullet_scene.instance()
	bullet_instance.init(polarity)
	bullet_instance.set_global_pos(get_node("ship/shoot_from").get_global_pos())
	add_child(bullet_instance)

func explode_ship(damage = 1):
	get_node("ship").explode()
	set_hits(hits+damage)

func steal():
	if global.enemy.stealable:
		set_hits(hits - 10)
