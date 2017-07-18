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
		get_node("frames").set_frame(1)
	else:
		set_global_pos(get_global_pos()+get_node("../ship/shoot_from").get_global_pos()-get_node("tip").get_global_pos())

func _ready():
	set_scale(scale_baseline*pow(1+scale_step,steps-1))
	get_node("frames").get_material().set_shader_param("x", polarity == 1)
#	get_node("sound").play("laser")
	set_process(true)

func _on_bullet_area_enter(area):
	if area.is_in_group("enemies"):
		exploded = true
		area.explode(steps, area.polarity == polarity)
		queue_free()

func _on_visibility_exit_screen():
	if not exploded:
		get_node("../ship").ready2shoot = true
		get_node("../ship").charge = 0
	queue_free()

func init(_polarity):
	polarity = _polarity
