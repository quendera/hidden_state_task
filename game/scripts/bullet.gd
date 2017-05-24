extends Area2D

const SPEED = 600
var dir
var polarity
var visible_color
var targets
var super

func _process(delta):
	if polarity == 0:
		visible_color = "red"
	else:
		visible_color = "blue"
	set_color(visible_color)
	translate(delta*SPEED*dir)

func _ready():
#	if friendly:
#		get_node("sound").play("laser")
	set_process(true)
	if super:
		set_scale(get_scale()*4)

func _on_bullet_area_enter(area):
	if area.is_in_group("asteroids"):
		if area.polarity == polarity:
			if rand_range(0,1) < get_node("../").accuracy:
				area.life = 0
			if super:
				area.life = 0
#					get_node("../ship").active = true
		queue_free()

func _on_visibility_exit_screen():
	queue_free()

func set_color(chosen_color):
	for color in ["red","blue", "masked"]:
		get_node(color).set_hidden(color != chosen_color)