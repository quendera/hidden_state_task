extends Area2D

const SPEED = 2000
var polarity # 0 is red, 1 is blue
var steps = 0
var exploded = false
var detached = false
var scale_baseline = Vector2(0.3, 0.3)
var scale_step = 0.7

func _process(delta):
	set_scale(scale_baseline*pow(1+scale_step,steps-1))
	if detached:
		translate(delta*SPEED*Vector2(1,0))
	else:
		set_global_pos(get_global_pos()+get_node("../ship/shoot_from").get_global_pos()-get_node("tip").get_global_pos())

func _ready():
	set_scale(scale_baseline*pow(1+scale_step,steps-1))
	get_node("frames").set_frame(polarity)
#	get_node("sound").play("laser")
	set_process(true)

func _on_bullet_area_enter(area):
	if area.is_in_group("enemies"):
		exploded = true
		get_node("../").data["time"].push_back(OS.get_ticks_msec())
		get_node("../").data["polarity_shot"].push_back(polarity)
		get_node("../").data["polarity_asteroid"].push_back(area.polarity)
		if area.polarity == polarity:
			area.explode(steps)
		else:
			area.reflect(steps)
		queue_free()

func _on_visibility_exit_screen():
	if true:#not exploded:
		get_node("../ship").ready2shoot = true
		get_node("../ship").charge = 0
	queue_free()

func init(_polarity):
	polarity = _polarity
