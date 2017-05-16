extends Area2D

# class member variables go here, for example:
var ship_pos
var velocity = 500

func _ready():
	set_process(true)

func _process(delta):
	ship_pos = get_pos()
	draw_circle(ship_pos, 20, Color(1,0,0))
	if Input.is_action_pressed("ui_left"):
		ship_pos.x -= delta*velocity
	if Input.is_action_pressed("ui_right"):
		ship_pos.x += delta*velocity
	if Input.is_action_pressed("ui_up"):
		ship_pos.y -= delta*velocity
	if Input.is_action_pressed("ui_down"):
		ship_pos.y += delta*velocity
	ship_pos.x = clamp(ship_pos.x, 100, 600)
	ship_pos.y = clamp(ship_pos.y, 200, 950)
	set_pos(ship_pos)

