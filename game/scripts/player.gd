extends Node2D

# class member variables go here, for example:
const FLIP_TIME = 300

var polarity setget set_polarity

#var hits setget set_hits
var steps = 0
var time0 = 0
var button_pressed = false
var ready2shoot = true
var ready2shield = false
var shooting_pressed = false
var shooting = false
var bullet_scene = preload("res://scenes/bullet.tscn")
var bullet_instance
var charge = 0
var charging_velocity = 100

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
		get_node("ship").explode()

func _ready():
	get_node("ship").connect("exploded", self, "_on_ship_exploded")
	set_polarity( int(rand_range(0,1) > 0.5) )
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
		get_node("ship").steal()

func _process(delta):
	if ready2shoot:
		ready2shield = false
	shooting_pressed = button_pressed and (OS.get_ticks_msec() > time0+FLIP_TIME)
	get_node("layer/hits").set_text("HITS "+str(get_node("ship").hits))
	get_node("layer/powerup/bars").set_frame(steps)
	if shooting_pressed and ready2shoot and not get_node("ship").active:
		if not shooting:
			shooting = true
			spawn_bullet(polarity)
		charge = clamp(charge+delta*charging_velocity, 0, 100)
		bullet_instance.steps = steps
	if not shooting_pressed and shooting:
		bullet_instance.detached = true
		shooting = false
		ready2shoot = false
	steps = int(floor(charge/25))+(charge > 0 )

func spawn_bullet(polarity):
	bullet_instance = bullet_scene.instance()
	bullet_instance.init(polarity)
	bullet_instance.set_global_pos(get_node("ship/shoot_from").get_global_pos())
	add_child(bullet_instance)
