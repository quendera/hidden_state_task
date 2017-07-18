extends Node2D

# class member variables go here, for example:
const FLIP_TIME = 300

var polarity setget set_polarity
var time0 = 0
var button_pressed


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

func _process(delta):
	get_node("ship").shooting_pressed = button_pressed and (OS.get_ticks_msec() > time0+FLIP_TIME)