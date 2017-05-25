extends Area2D

const SPEED = 1000
var polarity # 0 is red, 1 is blue
var super

func _process(delta):
	get_node("frames").set_frame(polarity)
	translate(delta*SPEED*Vector2(0,-1))

func _ready():
	get_node("sound").play("laser")
	set_process(true)
	if super:
		set_scale(get_scale()*4)

func _on_bullet_area_enter(area):
	if area.is_in_group("asteroids"):
		get_node("../").data["time"].push_back(OS.get_ticks_msec())
		get_node("../").data["polarity_shot"].push_back(polarity)
		get_node("../").data["polarity_asteroid"].push_back(area.polarity)
		if area.polarity == polarity:
			if rand_range(0,1) < get_node("../").accuracy:
				area.life = 0
			if super:
				area.life = 0
		queue_free()

func _on_visibility_exit_screen():
	queue_free()

func init(_polarity, _super):
	polarity = _polarity
	super = _super