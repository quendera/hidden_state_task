extends Area2D

const SPEED = 600
var hit = false
var bullet_dir

func _process(delta):
	translate(delta*SPEED*bullet_dir)

func _ready():
	set_process(true)

	
func _on_enemy_bullet_area_enter(area):
	if area.has_method("destroy"):
		area.destroy()
	if area.get_name() in ["ship", "shield1", "shield2"]:
		queue_free()

func _on_visibility_exit_screen():
	queue_free()

func _on_enemy_bullet_input_event(viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		queue_free()