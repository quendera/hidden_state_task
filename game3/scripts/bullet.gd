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
		position += $"../ship/shoot_from".global_position-$tip.global_position

func _ready():
	set_scale(scale_baseline*pow(1+scale_step,steps-1))
	get_node("frames").get_material().set_shader_param("x", polarity == 1)
	set_process(true)

func _on_bullet_area_enter(area):
	if area.is_in_group("enemies"):
		exploded = true
		if area.polarity == polarity:
			area.explode(steps)
		else:
			area.reflect(steps)
		queue_free()

func _on_visibility_exit_screen():
	if not exploded:
		get_parent().ready2shoot = true
		get_parent().charge = 0
	queue_free()

func init(_polarity):
	polarity = _polarity
