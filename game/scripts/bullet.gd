extends Area2D

const SPEED = 2000
var polarity # 0 is red, 1 is blue
var power
var exploded = false

func _process(delta):
	get_node("frames").set_frame(polarity)
	translate(delta*SPEED*Vector2(1,0))

func _ready():
	get_node("sound").play("laser")
	set_process(true)
	set_scale(get_scale()*power/30+Vector2(0.2,0.2))

func _on_bullet_area_enter(area):
	if area.is_in_group("enemies"):
		exploded = true
		get_node("../").data["time"].push_back(OS.get_ticks_msec())
		get_node("../").data["polarity_shot"].push_back(polarity)
		get_node("../").data["polarity_asteroid"].push_back(area.polarity)
		if area.polarity == polarity:
			area.explode(power)
		else:
			area.reflect(power)
		queue_free()

func _on_visibility_exit_screen():
	if true:#not exploded:
		get_node("../ship").ready2shoot = true
		get_node("../ship").charge = 0
	queue_free()

func init(_polarity, _power):
	polarity = _polarity
	power = _power
