extends Area2D

# class member variables go here, for example:
var score = 0
var ship_pos
var velocity = 600
var reload = 0
var reload_time = 0.1

func _ready():
	set_process(true)

func _process(delta):
	get_node("../score").set_text("Score :"+str(score))
	reload += delta
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
	if Input.is_action_pressed("shoot") and reload >= reload_time:
		get_node("../").spawn_bullet(ship_pos, Vector2(0,-1), get_node("shield").polarity, true, false)
		reload = 0
	ship_pos.x = clamp(ship_pos.x, 100, 600)
	ship_pos.y = clamp(ship_pos.y, 200, 1150)
	set_pos(ship_pos)

func destroy():
	get_node("anim").play("explosion")
	get_node("sound").play("explosion")
	score -=15

