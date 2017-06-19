extends Area2D

const SPEED = 1500
var polarity # 0 is red, 1 is blue
var power

func _process(delta):
	get_node("frames").set_frame(polarity)
	translate(delta*SPEED*Vector2(1,0))

func _ready():
	get_node("sound").play("laser")
	set_process(true)
	set_scale(get_scale()*power/30+Vector2(0.2,0.2))

func _on_bullet_area_enter(area):
	if area.is_in_group("enemies"):
		get_node("../").data["time"].push_back(OS.get_ticks_msec())
		get_node("../").data["polarity_shot"].push_back(polarity)
		get_node("../").data["polarity_asteroid"].push_back(area.polarity)
		if area.polarity == polarity:
			area.explode(power)
		else:
			area.reflect(power)
		queue_free()

func _on_visibility_exit_screen():
	queue_free()

func init(_polarity, _power):
	polarity = _polarity
	power = _power

func _on_bullet_exit_tree():
	pass
#get_node("../ship").ready2shoot = true
