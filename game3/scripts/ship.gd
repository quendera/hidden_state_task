#Functionality:
#	move, shield and explode.
#	Emit exploded signal when hit by an enemy bullet


extends Area2D

signal exploded(enemy_polarity)

const LAG = 0.1
var escaped = false

var active = false setget set_active

func set_active(new_active):
	active = new_active
	get_node("shader").set_visible(new_active)
	set_z(1+2*int(new_active))

var movement_time = 0
var start_time = 0


var velocity = 400


var exploding = false

var ship_displace = Vector2(0,0)
var dirs = {"ui_left":Vector2(-1,0), "ui_right":Vector2(1,0), "ui_up":Vector2(0,-1), "ui_down":Vector2(0,1)}
var pos_touch = Vector2(0,0)
var move_touch = false
var dir_touch = Vector2(0,0)
var pressed = false


func _ready():
	randomize()
	set_process(true)
	set_process_input(true)


func _input(event):
	if (event is InputEventScreenDrag) or (event is InputEventScreenDrag):
		pos_touch = event.pos
		pressed = (InputEventScreenDrag) or event.is_pressed()


func _process(delta):
# move the ship:
	var sum_dir = Vector2(0,0)
	for dir in dirs.keys():
		if Input.is_action_pressed(dir):
			sum_dir += dirs[dir]
	ship_displace += (sum_dir*velocity-ship_displace)*delta/LAG
	position += delta*ship_displace
	dir_touch = pos_touch-get_node("joystick").get_global_position()
	move_touch = pressed and dir_touch.length()<get_node("joystick").ray
	if move_touch:
		position += min(dir_touch.length(),2*velocity*delta)*dir_touch.normalized()
	position.x = clamp(position.x, 80, global.w*0.35)
	position.y = clamp(position.y, global.h*0.22, global.h*0.92)



func explode():
	if not exploding:
		get_node("sound").play("explosion")
		get_node("anim").play("explosion")


func _on_anim_animation_started( name ):
	exploding = true


func _on_anim_finished():
	exploding = false


func shield(ready2shield):
	if not active:
		if movement_time == 0:
			movement_time = OS.get_ticks_msec()-start_time
		if ready2shield:
			set_active(true)
			get_node("shield_off").start()



