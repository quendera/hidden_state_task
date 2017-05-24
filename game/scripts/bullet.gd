extends Area2D

const SPEED = 600
var dir
var polarity # 0 is red, 1 is blue
var targets
var super

func _process(delta):
	get_node("frames").set_frame(polarity)
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
		queue_free()

func _on_visibility_exit_screen():
	queue_free()